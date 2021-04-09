CREATE TABLE "subnational_region" (
"id" SERIAL NOT NULL ,
"country" INTEGER NOT NULL ,
"name" TEXT NOT NULL ,
PRIMARY KEY ("id") ,
UNIQUE ("id", "name")
);

ALTER TABLE "subnational_region" ADD FOREIGN KEY ("country") REFERENCES "country" ("id");

CREATE TABLE "subnational_demographic_statistic" (
"region" INTEGER NOT NULL ,
"age_from" INTEGER NOT NULL ,
"age_to" INTEGER NOT NULL ,
"value" REAL NOT NULL ,
"year" DECIMAL NOT NULL ,
"gender" INTEGER NOT NULL ,
"demographic_dataset" INTEGER NOT NULL
);

ALTER TABLE "subnational_demographic_statistic" ADD FOREIGN KEY ("region") REFERENCES "subnational_region" ("id");
ALTER TABLE "subnational_demographic_statistic" ADD FOREIGN KEY ("gender") REFERENCES "gender" ("id");
ALTER TABLE "subnational_demographic_statistic" ADD FOREIGN KEY ("demographic_dataset") REFERENCES "demographic_dataset" ("id");
