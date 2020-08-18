#!/usr/bin/env python3
import docker
import json
import os
import os.path
import shutil
import subprocess
import sys
from datetime import datetime
import dateutil.parser


def datetime_format(x):
    return x.strftime('%Y-%m-%d %H:%M:%S')


def read_json(filename):
    with open(filename, 'r') as f:
        return json.load(f)


def build_schemaspy():
    client = docker.from_env()
    tag = 'schemaspy.latest'
    img = client.images.build(path='.', tag=tag)
    return tag


def git_commit(db_sha, local_docs_path):
    print("creating commit")
    msg = 'Generated docs for db version {sha}'.format(sha=db_sha)
    try:
        subprocess.run(['git', '-C', local_docs_path, 'add', 'docs/' + db_sha,
                        'index.html', 'latest'],
                       check=True)
        subprocess.run(['git', '-C', local_docs_path, 'commit', '--no-verify',
                        '-m', msg],
                       check=True)
    except Exception as err:
        subprocess.run(['git', '-C', local_docs_path, 'reset'], check=False)
        raise err


def generate(db_sha, local_docs_path):
    registry = 'vimc'
    db_image_name = '{registry}/montagu-db:{db_sha}'.format(
        db_sha=db_sha, registry=registry)
    migrate_image_name = '{registry}/montagu-migrate:{db_sha}'.format(
        db_sha=db_sha, registry=registry)

    nw_name = 'migration_test'
    db_name = 'db'
    client = docker.from_env()
    command = '-host {db} -db montagu -u vimc '.format(db=db_name) + \
              '-p changeme -s public -o /output'
    dest = os.path.join(local_docs_path, 'docs', db_sha)
    volumes = {os.path.abspath(dest): {'bind': '/output', 'mode': 'rw'}}
    uid = os.geteuid()
    schemaspy = build_schemaspy()
    if os.path.exists(dest):
        if os.path.exists(dest + '/info.json'):
            print("Already created docs for '{}'".format(db_sha))
            return False
    else:
        os.makedirs(dest)

    nw = db = None
    success = False
    try:
        print("generating documentation for " + db_sha)
        print("- starting database container")
        nw = client.networks.create(nw_name)
        db = client.containers.run(db_image_name,
                                   network=nw.name,
                                   detach=True,
                                   name='db')
        db.exec_run("montagu-wait.sh")
        date_image = dateutil.parser.parse(db.image.attrs['Created'])
        print("- performing migrations")
        client.containers.run(migrate_image_name, network=nw.name,
                              remove=True)
        print("- documenting schema")
        client.containers.run(schemaspy,
                              command,
                              remove=True,
                              network=nw_name,
                              volumes=volumes,
                              user=uid,
                              stdout=True)
        info = {'sha': db_sha,
                'date_image': datetime_format(date_image),
                'date_generated': datetime_format(datetime.now())}
        with open(dest + '/info.json', 'w') as f:
            json.dump(info, f)
        generate_index(local_docs_path)
        git_commit(db_sha, local_docs_path)
        success = True
    finally:
        if db:
            db.remove(force = True)
        if nw:
            nw.remove()
        if not success:
            print("removing generated docs")
            shutil.rmtree(dest)

    return True


def generate_index(local_docs_path):
    print("updating index")

    paths = [os.path.join(local_docs_path, 'docs', x, 'info.json')
             for x in os.listdir(os.path.join(local_docs_path, 'docs'))]
    dat = [read_json(p) for p in paths if os.path.exists(p)]
    dat = sorted(dat, key=lambda x: x['date_image'], reverse=True)

    with open('index.html.template', 'r') as f:
        template = f.read()
    fmt = '<li><a href = docs/{sha}/index.html>{sha}</a> ' + \
          '({date_image}, generated {date_generated})</li>'

    data = dat[0]
    data['versions'] = '\n'.join([fmt.format(**i) for i in dat])
    index = template.format(**data)
    with open(os.path.join(local_docs_path, 'index.html'), 'w') as f:
        f.write(index)

    latest = os.path.join(local_docs_path, "latest")
    if os.path.exists(latest):
        os.remove(latest)
    os.symlink('docs/' + data['sha'] + "/", latest)


if __name__ == "__main__":
    root = os.path.dirname(os.path.realpath(__file__))
    os.chdir(root)
    args = sys.argv[1:]
    if len(args) != 2:
        raise Exception("Expected exactly two arguments")
    generate(args[0], args[1])
