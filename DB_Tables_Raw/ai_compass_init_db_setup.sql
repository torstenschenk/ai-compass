CREATE TABLE "questions" (
  "question_id" integer PRIMARY KEY,
  "dimension_id" integer,
  "header" varchar,
  "question_text" varchar,
  "type" varchar,
  "weight" float,
  "optional" boolean
);

CREATE TABLE "answers" (
  "answer_id" integer PRIMARY KEY,
  "question_id" integer,
  "answer_text" varchar,
  "answer_level" integer,
  "answer_weight" float
);

CREATE TABLE "dimensions" (
  "dimension_id" integer PRIMARY KEY,
  "dimension_name" varchar,
  "dimension_weight" float
);

CREATE TABLE "companies" (
  "company_id" integer PRIMARY KEY,
  "industry" varchar,
  "website" varchar,
  "number_of_employees" integer,
  "city" varchar
);

CREATE TABLE "responses" (
  "response_id" integer PRIMARY KEY,
  "company_id" integer,
  "total_score" varchar,
  "created_at" timestamp
);

CREATE TABLE "response_items" (
  "item_id" integer PRIMARY KEY,
  "response_id" integer,
  "question_id" integer,
  "answers" text
);

ALTER TABLE "answers" ADD FOREIGN KEY ("question_id") REFERENCES "questions" ("question_id");

ALTER TABLE "responses" ADD FOREIGN KEY ("company_id") REFERENCES "companies" ("company_id");

ALTER TABLE "response_items" ADD FOREIGN KEY ("question_id") REFERENCES "questions" ("question_id");

ALTER TABLE "response_items" ADD FOREIGN KEY ("response_id") REFERENCES "responses" ("response_id");

ALTER TABLE "questions" ADD FOREIGN KEY ("dimension_id") REFERENCES "dimensions" ("dimension_id");
