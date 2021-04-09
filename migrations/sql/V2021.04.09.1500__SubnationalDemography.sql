CREATE TABLE "region_subnational" (
"id" SERIAL NOT NULL ,
"country" INTEGER NOT NULL ,
"name" TEXT NOT NULL ,
"admin_level" INTEGER NOT NULL ,
"parent_id" INTEGER NULL,
PRIMARY KEY ("id") ,
UNIQUE ("id", "name")
);

ALTER TABLE "region_subnational" ADD FOREIGN KEY ("country") REFERENCES "country" ("nid");

CREATE TABLE "demographic_subnational_statistic" (
"id" SERIAL NOT NULL ,
"region" INTEGER NOT NULL ,
"age_from" INTEGER NOT NULL ,
"age_to" INTEGER NOT NULL ,
"value" DECIMAL NOT NULL ,
"year" INTEGER NOT NULL ,
"gender" INTEGER NOT NULL ,
"demographic_dataset" INTEGER NOT NULL
);

ALTER TABLE "demographic_subnational_statistic" ADD FOREIGN KEY ("region") REFERENCES "region_subnational" ("id");
ALTER TABLE "demographic_subnational_statistic" ADD FOREIGN KEY ("gender") REFERENCES "gender" ("id");
ALTER TABLE "demographic_subnational_statistic" ADD FOREIGN KEY ("demographic_dataset") REFERENCES "demographic_dataset" ("id");
