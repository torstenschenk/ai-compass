--
-- PostgreSQL database dump
--

\restrict OftCglbVyO9z4uOnrasKbYq0DUqCtYWJ1cBySpWcvzgJr5cwWqnszmc4oUCkM8o

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

SET statement_timeout = 0;

SET lock_timeout = 0;

SET idle_in_transaction_session_timeout = 0;

SET transaction_timeout = 0;

SET client_encoding = 'UTF8';

SET standard_conforming_strings = on;

SELECT pg_catalog.set_config ('search_path', '', false);

SET check_function_bodies = false;

SET xmloption = content;

SET client_min_messages = warning;

SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;

ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: answers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.answers (
    answer_id integer NOT NULL,
    question_id integer,
    answer_text character varying,
    answer_level integer,
    answer_weight double precision
);

ALTER TABLE public.answers OWNER TO postgres;

--
-- Name: answers_answer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.answers_answer_id_seq AS integer START
WITH
    1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;

ALTER SEQUENCE public.answers_answer_id_seq OWNER TO postgres;

--
-- Name: answers_answer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.answers_answer_id_seq OWNED BY public.answers.answer_id;

--
-- Name: cluster_profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cluster_profiles (
    cluster_id bigint NOT NULL,
    cluster_name character varying,
    description character varying,
    score_min double precision,
    score_max double precision
);

ALTER TABLE public.cluster_profiles OWNER TO postgres;

--
-- Name: cluster_profiles_cluster_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cluster_profiles_cluster_id_seq START
WITH
    1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;

ALTER SEQUENCE public.cluster_profiles_cluster_id_seq OWNER TO postgres;

--
-- Name: cluster_profiles_cluster_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cluster_profiles_cluster_id_seq OWNED BY public.cluster_profiles.cluster_id;

--
-- Name: companies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.companies (
    company_id integer NOT NULL,
    company_name character varying,
    industry character varying,
    website character varying,
    number_of_employees character varying,
    city character varying,
    email text
);

ALTER TABLE public.companies OWNER TO postgres;

--
-- Name: companies_company_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.companies_company_id_seq AS integer START
WITH
    1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;

ALTER SEQUENCE public.companies_company_id_seq OWNER TO postgres;

--
-- Name: companies_company_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.companies_company_id_seq OWNED BY public.companies.company_id;

--
-- Name: dimensions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dimensions (
    dimension_id integer NOT NULL,
    dimension_name character varying,
    dimension_weight double precision
);

ALTER TABLE public.dimensions OWNER TO postgres;

--
-- Name: dimensions_dimension_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dimensions_dimension_id_seq AS integer START
WITH
    1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;

ALTER SEQUENCE public.dimensions_dimension_id_seq OWNER TO postgres;

--
-- Name: dimensions_dimension_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dimensions_dimension_id_seq OWNED BY public.dimensions.dimension_id;

--
-- Name: questions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.questions (
    question_id integer NOT NULL,
    dimension_id integer,
    header character varying,
    question_text character varying,
    type character varying,
    weight double precision,
    optional boolean
);

ALTER TABLE public.questions OWNER TO postgres;

--
-- Name: questions_question_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.questions_question_id_seq AS integer START
WITH
    1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;

ALTER SEQUENCE public.questions_question_id_seq OWNER TO postgres;

--
-- Name: questions_question_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.questions_question_id_seq OWNED BY public.questions.question_id;

--
-- Name: response_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.response_items (
    item_id integer NOT NULL,
    response_id integer,
    question_id integer,
    answers integer[]
);

ALTER TABLE public.response_items OWNER TO postgres;

--
-- Name: response_items_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.response_items_item_id_seq AS integer START
WITH
    1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;

ALTER SEQUENCE public.response_items_item_id_seq OWNER TO postgres;

--
-- Name: response_items_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.response_items_item_id_seq OWNED BY public.response_items.item_id;

--
-- Name: responses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.responses (
    response_id integer NOT NULL,
    company_id integer,
    total_score character varying,
    created_at text,
    cluster_id bigint,
    ab_group character varying
);

ALTER TABLE public.responses OWNER TO postgres;

--
-- Name: responses_response_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.responses_response_id_seq AS integer START
WITH
    1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;

ALTER SEQUENCE public.responses_response_id_seq OWNER TO postgres;

--
-- Name: responses_response_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.responses_response_id_seq OWNED BY public.responses.response_id;

--
-- Name: answers answer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answers
ALTER COLUMN answer_id
SET DEFAULT nextval(
    'public.answers_answer_id_seq'::regclass
);

--
-- Name: cluster_profiles cluster_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cluster_profiles
ALTER COLUMN cluster_id
SET DEFAULT nextval(
    'public.cluster_profiles_cluster_id_seq'::regclass
);

--
-- Name: companies company_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.companies
ALTER COLUMN company_id
SET DEFAULT nextval(
    'public.companies_company_id_seq'::regclass
);

--
-- Name: dimensions dimension_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dimensions
ALTER COLUMN dimension_id
SET DEFAULT nextval(
    'public.dimensions_dimension_id_seq'::regclass
);

--
-- Name: questions question_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
ALTER COLUMN question_id
SET DEFAULT nextval(
    'public.questions_question_id_seq'::regclass
);

--
-- Name: response_items item_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.response_items
ALTER COLUMN item_id
SET DEFAULT nextval(
    'public.response_items_item_id_seq'::regclass
);

--
-- Name: responses response_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.responses
ALTER COLUMN response_id
SET DEFAULT nextval(
    'public.responses_response_id_seq'::regclass
);

--
-- Data for Name: answers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.answers (
    answer_id,
    question_id,
    answer_text,
    answer_level,
    answer_weight
)
FROM stdin;

1	1	Not a topic / Ignored	1	1
2	1	Rare mention in meetings	2	2
3	1	Occasional discussion	3	3
4	1	Regular agenda item	4	4
5	1	Core strategic pillar	5	5
6	2	None / No plan	1	1
7	2	Rough ideas shared	2	2
8	2	High-level draft exists	3	3
9	2	Formalized document	4	4
10	2	Approved & detailed	5	5
11	3	No budget available	1	1
12	3	Case-by-case funding	2	2
13	3	Ad-hoc project funds	3	3
14	3	Dedicated Dept. budget	4	4
15	3	Fixed annual AI budget	5	5
16	4	Avoidance / Refusal	1	1
17	4	Late adopter	2	2
18	4	Fast Follower	3	3
19	4	Proactive innovator	4	4
20	4	Market Leader	5	5
21	5	Fear / Resistance	1	1
22	5	Skeptical / Passive	2	2
23	5	Neutral / Cautious	3	3
24	5	Interested / Open	4	4
25	5	Proactive excitement	5	5
26	6	Unaware / Non-Existent - We lack clarity on our current AI proficiency, and there are no identifiable AI skills or initiatives within the workforce.	1	1
27	6	Isolated Proficiency - AI knowledge is siloed within a few individuals;

significant skill gaps across most departments currently hinder broader adoption.	2	2
28	6	Foundational Competency -  Core team members possess foundational AI skills, and structured upskilling programs are underway to prepare the broader workforce.	3	3
29	6	Advanced Operational Capability - Advanced AI practitioners are integrated into multiple roles, supported by continuous training that keeps pace with industry trends.	4	4
30	6	Strategic Expert Leadership - AI expertise is a core competency company-wide;

internal specialists lead R&D, mentor staff, and drive industry-leading innovation.	5	5
31	7	Never / None	1	1
32	7	Occasional webinars	2	2
33	7	Irregular workshops	3	3
34	7	Planned curriculums	4	4
35	7	Continuous learning	5	5
36	8	Failure is punished	1	1
37	8	Blame culture	2	2
38	8	Failure is tolerated	3	3
39	8	Learning from errors	4	4
40	8	Fail-fast encouraged	5	5
41	9	Sales and transaction data	1	25
42	9	Customer interactions (emails, chats, calls)	2	10
43	9	Website/app usage analytics	3	15
44	9	Customer feedback and reviews	4	15
45	9	Product data	5	20
46	9	Financial and operational metrics	6	10
47	9	Employee/HR data	7	5
48	9	Limited data collection (Exclusive option)	8	0
49	10	Internal (on-premise) servers	1	5
50	10	Cloud platforms (AWS, Azure, Google Cloud)	2	25
51	10	CRM systems (Salesforce, HubSpot, etc.)	3	11
52	10	ERP System�	4	11
53	10	E-commerce platforms (Shopify, WooCommerce, etc.)	5	10
54	10	Business intelligence tools (Tableau, Power BI, etc.)	6	18
55	10	API integrations between systems	7	20
56	10	None of the above (Exclusive option)?	8	0
57	11	Messy / Siloed	1	1
58	11	Basic digital records	2	2
59	11	Partially cleaned	3	3
60	11	Standardized formats	4	4
61	11	High-quality/Auto-sync	5	5
62	12	Struggling / No skill	1	1
63	12	Basic tool awareness	2	2
64	12	Comfortable with KPIs	3	3
65	12	Analytical mindsets	4	4
66	12	Data-driven experts	5	5
67	13	Minimal / Unsure � We do not have a formal feasibility check;

projects are often started based on excitement or intuition without verifying data or compliance requirements first.	1	1
68	13	Reactive Assessment � We perform basic checks only after a project has started, often leading to delays or "stuck" projects when data or legal issues unexpectedly emerge.	2	2
69	13	Basic Due Diligence � We have an informal "Pre-Check" for major projects where we verify if the necessary data exists and if there are obvious legal hurdles.	3	3
70	13	Structured Validation � We use a clear "Go/No-Go" process for every use case that validates data readiness, process alignment, and regulatory compliance before any budget is released.	4	4
71	13	Optimized Strategic Filtering � We use a standardized, data-driven validation engine that ensures every initiative is perfectly aligned with business goals, technical capabilities, and compliance standards from the start.	5	5
72	14	Not started 	1	1
73	14	Theory / Brainstorm	2	2
74	14	1-2 Active Pilots	3	3
75	14	Multiple live apps	4	4
76	14	AI embedded in product	5	5
77	15	No tracking	1	1
78	15	Cost tracking only	2	2
79	15	Qualitative impact	3	3
80	15	Defined KPI tracking	4	4
81	15	Strict Financial ROI	5	5
82	16	AI initiatives are mostly exploratory and disconnected from core business bottlenecks.\n\n	1	1
83	16	Some AI use cases touch core processes, but they are not focused on the most critical constraints.	2	2
84	16	AI is applied to known bottlenecks in the core business, with mixed or unproven impact.	3	3
85	16	AI systematically targets high-impact bottlenecks in core business operations and delivers measurable improvements.	4	4
86	16	AI is a strategic lever to remove or redefine core business bottlenecks and shapes how the business competes.	5	5
87	17	Knowledge in heads	1	1
88	17	Rough checklists	2	2
89	17	Partially documented	3	3
90	17	Standard SOPs	4	4
91	17	Fully digital workflows	5	5
92	18	Undefined / Ad-hoc � We do not have a set process for AI projects;

tasks are handled as they arise without formal planning or clear ownership.	1	1
93	18	Individual Initiative � Project delivery depends on the effort of specific individuals;

while some projects succeed, we lack a repeatable "playbook" for the whole team.	2	2
94	18	Basic Standardization � We use a consistent workflow (e.g., simple task tracking or weekly sprints) that allows us to manage AI projects with predictable timelines.	3	3
95	18	Targeted & Results-Oriented � We use a process specifically adapted for AI (e.g., early prototyping and data-readiness checks), ensuring we don't waste resources on unfeasible ideas.	4	4
96	18	High-Velocity Delivery � Our implementation engine is highly efficient; we can rapidly move from a "Proof of Concept" to a live tool with minimal friction and clear ROI tracking.	5	5
97	19	> 1 Year	1	1
98	19	7 - 12 Months	2	2
99	19	3 - 6 Months	3	3
100	19	1 - 2 Months	4	4
101	19	< 4 Weeks	5	5
102	20	No plan	1	1
103	20	Theoretical idea	2	2
104	20	Case-by-case choice	3	3
105	20	Defined scaling path	4	4
106	20	Automated deployment	5	5
107	21	None	1	1
108	21	Informal rules	2	2
109	21	In progress / Draft	3	3
110	21	Implemented policy	4	4
111	21	Audited Governance	5	5
112	22	High Risk / Unknown	1	1
113	22	Minimal compliance	2	2
114	22	Basic GDPR active	3	3
115	22	Privacy-by-design	4	4
116	22	Full sovereignty	5	5
117	23	No one responsible	1	1
118	23	Vague / individual assignments	2	2
119	23	Shared responsibility	3	3
120	23	Clear Dept. lead	4	4
121	23	Dedicated AI Officer	5	5
122	24	Unknown\n	1	1
123	24	Defined by Partners	2	2
124	24	Minimal	3	3
125	24	Medium	4	4
126	24	High Disclosure	5	5
127	25	Fully On-Premise	1	1
128	25	Modernized On-Prem	2	2
129	25	Hybrid Cloud setup	3	3
130	25	Cloud-first approach	4	4
131	25	Cloud-Native	5	5
132	26	No AI development tools are currently available (Exclusive option)?	1	0
133	26	Pre-built AI tools or platforms (e.g., analytics, chatbots, automation tools)?	2	20
134	26	Custom AI or machine learning development tools?	3	20
135	26	Cloud-based AI services (e.g., managed AI/ML platforms)?	4	20
136	26	A combination of pre-built and custom AI tools?	5	40
137	26	Not sure	6	0
138	27	Manual/Painful	1	1
139	27	Labor intensive	2	2
140	27	Standard IT process	3	3
141	27	Modular & easy	4	4
142	27	Instant/Auto-scaling	5	5
143	28	External Pressure � We are responding to external hype or competitor moves without a clear internal goal.	1	0
144	28	Resource Optimization � We want to identify where AI can reduce costs or automate repetitive manual tasks.	2	0
145	28	Strategic Clarity � We need a professional roadmap to align AI initiatives with our core business objectives.	3	0
146	28	 Readiness Check � We aim to evaluate our technical infrastructure and workforce skills for upcoming scaling.	4	0
147	28	Competitive Advantage � We are seeking to define a market-leading position through high-impact AI innovation.	5	0
148	29	Improving customer service efficiency	1	0
149	29	Automating repetitive tasks	2	0
150	29	Better data analysis and insights	3	0
151	29	Enhancing search/recommendation capabilities	4	0
152	29	Streamlining document processing	5	0
153	29	Personalizing customer experiences	6	0
154	29	Reducing operational costs	7	0
155	29	Other	8	0
156	30	No Impact � We have not assessed AI trends and have no documented strategy regarding them.	1	0
157	30	Reactive � We acknowledge the trend but only respond to external pressures on an ad-hoc basis.	2	0
158	30	Exploratory � We monitor trends and have initiated pilot projects to address specific needs.	3	0
159	30	Strategic � AI is a key planning driver with a formal roadmap for systematic integration.	4	0
160	30	Innovative � We leverage AI to redefine our business model and set industry standards.	5	0
161	31	Executive Leadership / Board 	1	0
162	31	IT / Technology Department 	2	0
163	31	Digital Transformation / Innovation Team 	3	0
164	31	Sales & Marketing	4	0
165	31	Operations & Supply Chain 	5	0
166	31	Data Science / Analytics Specialists 	6	0
167	31	Individual Employees / Early Adopters 	7	0
168	31	External Partners / Consultants	8	0
169	31	No Clear Internal Driver 	9	0
170	32	No	1	0
171	32	Sometimes	2	0
172	32	Yes	3	0
173	33	Executive / C-level	1	0
174	33	Senior Management	2	0
175	33	Product / Process Owner	3	0
176	33	IT / Technology Management	4	0
177	33	Data / AI Specialist	5	0
178	33	Business Analyst / Strategy / Innovation role	6	0
179	33	Operational Staff / Domain Expert	7	0
180	33	Project / Program Manager	8	0
181	33	External Consultant / Advisor	9	0
\.


--
-- Data for Name: cluster_profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cluster_profiles (cluster_id, cluster_name, description, score_min, score_max) FROM stdin;
1	The Traditionalist	\N	1	1.5
2	The Experimental Explorer	\N	1.6	2.5
3	The Structured Builder	\N	2.6	3.5
4	The Operational Scaler	\N	3.6	4.5
5	The AI-Driven Leader	\N	4.6	5
\.


--
-- Data for Name: companies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.companies (company_id, company_name, industry, website, number_of_employees, city, email) FROM stdin;
3	Skyline Solutions	Construction	www.skyline-solutions.de	500+	Stuttgart	\N
6	Quantum Solutions	Hospitality	www.quantum-solutions.de	500+	D�sseldorf	\N
9	Zenith GmbH	Healthcare	www.zenith-gmbh.de	251-500	Cologne	\N
10	Vantage AG	Manufacturing	www.vantage-ag.de	251-500	D�sseldorf	\N
17	Peak AG	Construction	www.peak-ag.de	18264	Munich	\N
25	Alpha AG	Hospitality	www.alpha-ag.de	51-250	Cologne	\N
29	Nexus AG	Healthcare	www.nexus-ag.de	500+	Berlin	\N
31	Alpha SME	Manufacturing	www.alpha-sme.de	51-250	Berlin	\N
32	Quantum Group	Healthcare	www.quantum-group.de	500+	D�sseldorf	\N
33	Blue Harbor SME	Manufacturing	www.blue-harbor-sme.de	500+	Berlin	\N
34	Vantage Group	Construction	www.vantage-group.de	251-500	Munich	\N
36	Nexus GmbH	Finance	www.nexus-gmbh.de	51-250	Berlin	\N
42	Vantage Digital	Logistics	www.vantage-digital.de	51-250	Hamburg	\N
44	Peak Digital	Healthcare	www.peak-digital.de	18264	Munich	\N
45	Alpha Group	Retail	www.alpha-group.de	500+	Frankfurt	\N
46	Peak Logistics	Logistics	www.peak-logistics.de	500+	Stuttgart	\N
48	Vantage Solutions	Retail	www.vantage-solutions.de	251-500	Munich	\N
51	Alpha Solutions	Construction	www.alpha-solutions.de	500+	D�sseldorf	\N
57	Blue Harbor Solutions	Retail	www.blue-harbor-solutions.de	51-250	D�sseldorf	\N
65	Alpha Solutions	Manufacturing	www.alpha-solutions.de	18264	Hamburg	\N
70	Peak Group	Retail	www.peak-group.de	251-500	Munich	\N
78	Iron GmbH	Healthcare	www.iron-gmbh.de	51-250	Munich	\N
81	Peak SME	Retail	www.peak-sme.de	18264	Munich	\N
82	Nexus GmbH	Logistics	www.nexus-gmbh.de	18264	Munich	\N
83	Zenith GmbH	Logistics	www.zenith-gmbh.de	251-500	D�sseldorf	\N
85	Quantum Logistics	Finance	www.quantum-logistics.de	251-500	Frankfurt	\N
88	Nexus Digital	Finance	www.nexus-digital.de	251-500	Frankfurt	\N
89	Blue Harbor Logistics	Hospitality	www.blue-harbor-logistics.de	51-250	Berlin	\N
96	Nexus AG	Healthcare	www.nexus-ag.de	18264	Cologne	\N
97	Zenith Solutions	Finance	www.zenith-solutions.de	18264	Berlin	\N
99	Quantum Group	Healthcare	www.quantum-group.de	18264	Munich	\N
100	Blue Harbor Digital	Finance	www.blue-harbor-digital.de	18264	Munich	\N
102	Blue Harbor Digital	Manufacturing	www.blue-harbor-digital.de	51-250	D�sseldorf	\N
103	Iron GmbH	Logistics	www.iron-gmbh.de	18264	D�sseldorf	\N
108	Zenith Group	Manufacturing	www.zenith-group.de	51-250	Berlin	\N
112	Nexus Logistics	Construction	www.nexus-logistics.de	18264	Munich	\N
114	Alpha AG	Retail	www.alpha-ag.de	51-250	Frankfurt	\N
123	Nexus SME	Finance	www.nexus-sme.de	51-250	D�sseldorf	\N
126	Nexus SME	Hospitality	www.nexus-sme.de	500+	Hamburg	\N
127	Vantage Group	Manufacturing	www.vantage-group.de	51-250	Cologne	\N
129	Alpha Solutions	Manufacturing	www.alpha-solutions.de	500+	Frankfurt	\N
132	Alpha Logistics	Logistics	www.alpha-logistics.de	500+	Stuttgart	\N
133	Skyline SME	Hospitality	www.skyline-sme.de	18264	Stuttgart	\N
134	Vantage SME	Manufacturing	www.vantage-sme.de	500+	Stuttgart	\N
136	Vantage Digital	Manufacturing	www.vantage-digital.de	251-500	Cologne	\N
137	Blue Harbor Group	Finance	www.blue-harbor-group.de	18264	Frankfurt	\N
138	Iron AG	Retail	www.iron-ag.de	500+	Cologne	\N
142	Peak Digital	Construction	www.peak-digital.de	18264	Frankfurt	\N
144	Nexus GmbH	Retail	www.nexus-gmbh.de	18264	Hamburg	\N
147	Alpha SME	Construction	www.alpha-sme.de	51-250	Frankfurt	\N
148	Skyline Group	Healthcare	www.skyline-group.de	251-500	Frankfurt	\N
149	Blue Harbor AG	Construction	www.blue-harbor-ag.de	251-500	Hamburg	\N
150	Vantage GmbH	Healthcare	www.vantage-gmbh.de	18264	D�sseldorf	\N
152	Skyline AG	Construction	www.skyline-ag.de	51-250	D�sseldorf	\N
154	Quantum Solutions	Healthcare	www.quantum-solutions.de	251-500	Hamburg	\N
159	Iron Solutions	Logistics	www.iron-solutions.de	500+	Berlin	\N
180	Vantage AG	Retail	www.vantage-ag.de	500+	Frankfurt	\N
182	Peak AG	Logistics	www.peak-ag.de	51-250	Hamburg	\N
183	Quantum GmbH	Retail	www.quantum-gmbh.de	500+	Hamburg	\N
184	Quantum Digital	Logistics	www.quantum-digital.de	18264	D�sseldorf	\N
185	Alpha AG	Manufacturing	www.alpha-ag.de	500+	Cologne	\N
186	Vantage Digital	Construction	www.vantage-digital.de	251-500	D�sseldorf	\N
190	Peak Logistics	Manufacturing	www.peak-logistics.de	251-500	Berlin	\N
195	Zenith Digital	Logistics	www.zenith-digital.de	18264	Cologne	\N
196	Quantum GmbH	Hospitality	www.quantum-gmbh.de	18264	Stuttgart	\N
201	Blue Harbor Logistics	Finance	www.blue-harbor-logistics.de	51-250	Cologne	\N
206	Vantage Digital	Hospitality	www.vantage-digital.de	500+	Munich	\N
209	Blue Harbor Group	Manufacturing	www.blue-harbor-group.de	251-500	Munich	\N
210	Peak Logistics	Logistics	www.peak-logistics.de	18264	D�sseldorf	\N
212	Skyline Logistics	Finance	www.skyline-logistics.de	251-500	Munich	\N
215	Iron SME	Logistics	www.iron-sme.de	500+	Stuttgart	\N
217	Blue Harbor SME	Healthcare	www.blue-harbor-sme.de	51-250	Frankfurt	\N
222	Nexus Logistics	Hospitality	www.nexus-logistics.de	18264	Frankfurt	\N
223	Vantage SME	Retail	www.vantage-sme.de	18264	Stuttgart	\N
224	Nexus Digital	Retail	www.nexus-digital.de	51-250	Berlin	\N
228	Nexus AG	Manufacturing	www.nexus-ag.de	51-250	Hamburg	\N
229	Peak SME	Finance	www.peak-sme.de	251-500	Frankfurt	\N
233	Skyline Digital	Construction	www.skyline-digital.de	500+	Berlin	\N
234	Vantage SME	Logistics	www.vantage-sme.de	18264	D�sseldorf	\N
235	Alpha SME	Logistics	www.alpha-sme.de	500+	Cologne	\N
240	Skyline SME	Finance	www.skyline-sme.de	251-500	Frankfurt	\N
241	Vantage Logistics	Hospitality	www.vantage-logistics.de	51-250	Cologne	\N
243	Iron GmbH	Retail	www.iron-gmbh.de	500+	Stuttgart	\N
245	Quantum Logistics	Construction	www.quantum-logistics.de	51-250	Munich	\N
246	Skyline Solutions	Construction	www.skyline-solutions.de	18264	D�sseldorf	\N
253	Skyline Solutions	Manufacturing	www.skyline-solutions.de	251-500	Munich	\N
258	Zenith GmbH	Hospitality	www.zenith-gmbh.de	51-250	Stuttgart	\N
259	Nexus Solutions	Manufacturing	www.nexus-solutions.de	51-250	D�sseldorf	\N
260	Blue Harbor AG	Healthcare	www.blue-harbor-ag.de	18264	Cologne	\N
262	Vantage AG	Construction	www.vantage-ag.de	500+	Stuttgart	\N
263	Alpha Group	Finance	www.alpha-group.de	51-250	Cologne	\N
264	Zenith Digital	Hospitality	www.zenith-digital.de	18264	Hamburg	\N
266	Quantum Solutions	Construction	www.quantum-solutions.de	51-250	Frankfurt	\N
267	Alpha Group	Logistics	www.alpha-group.de	51-250	Hamburg	\N
269	Iron Solutions	Finance	www.iron-solutions.de	18264	Stuttgart	\N
272	Alpha Logistics	Healthcare	www.alpha-logistics.de	18264	Frankfurt	\N
273	Alpha GmbH	Retail	www.alpha-gmbh.de	500+	Berlin	\N
276	Iron Logistics	Manufacturing	www.iron-logistics.de	251-500	Frankfurt	\N
277	Nexus AG	Manufacturing	www.nexus-ag.de	51-250	D�sseldorf	\N
278	Blue Harbor Digital	Hospitality	www.blue-harbor-digital.de	51-250	D�sseldorf	\N
279	Alpha Group	Healthcare	www.alpha-group.de	500+	D�sseldorf	\N
282	Zenith SME	Hospitality	www.zenith-sme.de	18264	Berlin	\N
286	Peak Logistics	Manufacturing	www.peak-logistics.de	500+	Frankfurt	\N
287	Alpha Digital	Logistics	www.alpha-digital.de	251-500	Cologne	\N
291	Quantum AG	Retail	www.quantum-ag.de	51-250	Berlin	\N
294	Peak Solutions	Logistics	www.peak-solutions.de	251-500	Hamburg	\N
297	Iron GmbH	Healthcare	www.iron-gmbh.de	18264	Munich	\N
298	Blue Harbor Solutions	Healthcare	www.blue-harbor-solutions.de	251-500	Hamburg	\N
303	Alpha GmbH	Healthcare	www.alpha-gmbh.de	500+	D�sseldorf	\N
304	Iron GmbH	Logistics	www.iron-gmbh.de	51-250	Munich	\N
307	Vantage Logistics	Retail	www.vantage-logistics.de	18264	Stuttgart	\N
308	Nexus Digital	Manufacturing	www.nexus-digital.de	251-500	Hamburg	\N
310	Skyline GmbH	Manufacturing	www.skyline-gmbh.de	251-500	Munich	\N
311	Nexus Solutions	Healthcare	www.nexus-solutions.de	18264	D�sseldorf	\N
313	Blue Harbor Group	Logistics	www.blue-harbor-group.de	18264	Frankfurt	\N
314	Peak Solutions	Construction	www.peak-solutions.de	251-500	Cologne	\N
316	Quantum GmbH	Construction	www.quantum-gmbh.de	51-250	Munich	\N
318	Quantum Digital	Healthcare	www.quantum-digital.de	500+	Berlin	\N
319	Skyline GmbH	Logistics	www.skyline-gmbh.de	51-250	Berlin	\N
320	Quantum SME	Hospitality	www.quantum-sme.de	18264	D�sseldorf	\N
326	Nexus Logistics	Construction	www.nexus-logistics.de	18264	Berlin	\N
328	Iron GmbH	Finance	www.iron-gmbh.de	251-500	Munich	\N
329	Blue Harbor Group	Retail	www.blue-harbor-group.de	51-250	Hamburg	\N
331	Iron Solutions	Manufacturing	www.iron-solutions.de	18264	D�sseldorf	\N
334	Nexus SME	Logistics	www.nexus-sme.de	51-250	Berlin	\N
335	Zenith GmbH	Logistics	www.zenith-gmbh.de	251-500	Hamburg	\N
336	Iron SME	Logistics	www.iron-sme.de	51-250	Cologne	\N
341	Quantum Logistics	Retail	www.quantum-logistics.de	18264	Hamburg	\N
342	Vantage Logistics	Construction	www.vantage-logistics.de	500+	Munich	\N
343	Skyline Solutions	Hospitality	www.skyline-solutions.de	18264	D�sseldorf	\N
345	Skyline Digital	Retail	www.skyline-digital.de	51-250	Stuttgart	\N
347	Skyline Logistics	Manufacturing	www.skyline-logistics.de	251-500	Hamburg	\N
348	Quantum Logistics	Logistics	www.quantum-logistics.de	18264	Frankfurt	\N
356	Iron Digital	Finance	www.iron-digital.de	18264	D�sseldorf	\N
358	Nexus Logistics	Retail	www.nexus-logistics.de	18264	Munich	\N
363	Peak Solutions	Manufacturing	www.peak-solutions.de	500+	D�sseldorf	\N
366	Zenith SME	Healthcare	www.zenith-sme.de	500+	Berlin	\N
370	Alpha GmbH	Hospitality	www.alpha-gmbh.de	500+	Berlin	\N
372	Vantage SME	Retail	www.vantage-sme.de	251-500	Stuttgart	\N
380	Iron Logistics	Healthcare	www.iron-logistics.de	51-250	D�sseldorf	\N
386	Blue Harbor SME	Retail	www.blue-harbor-sme.de	18264	Frankfurt	\N
391	Peak SME	Finance	www.peak-sme.de	51-250	Hamburg	\N
403	Vantage GmbH	Finance	www.vantage-gmbh.de	18264	Hamburg	\N
405	Alpha Group	Healthcare	www.alpha-group.de	51-250	Stuttgart	\N
407	Alpha Digital	Healthcare	www.alpha-digital.de	500+	Berlin	\N
409	Blue Harbor Group	Construction	www.blue-harbor-group.de	500+	Hamburg	\N
415	Alpha Logistics	Logistics	www.alpha-logistics.de	51-250	Munich	\N
416	Peak AG	Healthcare	www.peak-ag.de	51-250	Berlin	\N
420	Zenith GmbH	Finance	www.zenith-gmbh.de	51-250	Cologne	\N
429	Blue Harbor AG	Retail	www.blue-harbor-ag.de	18264	Cologne	\N
430	Nexus AG	Logistics	www.nexus-ag.de	500+	Munich	\N
431	Vantage SME	Hospitality	www.vantage-sme.de	18264	Munich	\N
434	Iron Digital	Construction	www.iron-digital.de	51-250	Cologne	\N
436	Zenith Group	Healthcare	www.zenith-group.de	251-500	Hamburg	\N
439	Blue Harbor Digital	Manufacturing	www.blue-harbor-digital.de	51-250	Stuttgart	\N
441	Blue Harbor Logistics	Finance	www.blue-harbor-logistics.de	500+	Hamburg	\N
444	Zenith Logistics	Healthcare	www.zenith-logistics.de	51-250	Stuttgart	\N
445	Alpha Solutions	Finance	www.alpha-solutions.de	251-500	D�sseldorf	\N
450	Peak GmbH	Construction	www.peak-gmbh.de	251-500	D�sseldorf	\N
451	Skyline Group	Healthcare	www.skyline-group.de	18264	Frankfurt	\N
453	Iron SME	Retail	www.iron-sme.de	500+	Hamburg	\N
454	Vantage SME	Healthcare	www.vantage-sme.de	251-500	Munich	\N
456	Nexus Group	Finance	www.nexus-group.de	51-250	Berlin	\N
461	Alpha Logistics	Hospitality	www.alpha-logistics.de	500+	Hamburg	\N
462	Iron GmbH	Hospitality	www.iron-gmbh.de	251-500	Stuttgart	\N
463	Skyline GmbH	Manufacturing	www.skyline-gmbh.de	51-250	Hamburg	\N
465	Iron GmbH	Logistics	www.iron-gmbh.de	500+	Stuttgart	\N
471	Iron Group	Logistics	www.iron-group.de	18264	Berlin	\N
473	Iron SME	Manufacturing	www.iron-sme.de	51-250	D�sseldorf	\N
477	Zenith Solutions	Healthcare	www.zenith-solutions.de	18264	Hamburg	\N
488	Quantum Solutions	Construction	www.quantum-solutions.de	51-250	Munich	\N
492	Quantum Group	Retail	www.quantum-group.de	251-500	Frankfurt	\N
494	Skyline Logistics	Manufacturing	www.skyline-logistics.de	500+	Cologne	\N
496	Alpha SME	Retail	www.alpha-sme.de	500+	Stuttgart	\N
497	Vantage Solutions	Healthcare	www.vantage-solutions.de	251-500	Hamburg	\N
498	Iron SME	Manufacturing	www.iron-sme.de	18264	Frankfurt	\N
501	Nexus Digital	Finance	www.nexus-digital.de	51-250	D�sseldorf	\N
504	Alpha AG	Construction	www.alpha-ag.de	500+	Stuttgart	\N
511	Skyline AG	Healthcare	www.skyline-ag.de	500+	Hamburg	\N
515	Vantage SME	Retail	www.vantage-sme.de	500+	Hamburg	\N
516	Skyline SME	Logistics	www.skyline-sme.de	500+	D�sseldorf	\N
517	Iron Digital	Retail	www.iron-digital.de	51-250	Frankfurt	\N
520	Vantage SME	Construction	www.vantage-sme.de	251-500	Munich	\N
522	Skyline SME	Finance	www.skyline-sme.de	251-500	D�sseldorf	\N
524	Vantage Logistics	Retail	www.vantage-logistics.de	18264	Munich	\N
525	Skyline SME	Retail	www.skyline-sme.de	51-250	Munich	\N
527	Nexus AG	Healthcare	www.nexus-ag.de	500+	Frankfurt	\N
528	Quantum Group	Hospitality	www.quantum-group.de	51-250	Munich	\N
531	Peak AG	Manufacturing	www.peak-ag.de	18264	Berlin	\N
532	Nexus Solutions	Retail	www.nexus-solutions.de	18264	Berlin	\N
533	Vantage Digital	Finance	www.vantage-digital.de	51-250	Frankfurt	\N
539	Zenith Logistics	Healthcare	www.zenith-logistics.de	251-500	Munich	\N
542	Nexus Digital	Retail	www.nexus-digital.de	18264	Munich	\N
549	Vantage Digital	Healthcare	www.vantage-digital.de	51-250	D�sseldorf	\N
553	Vantage SME	Retail	www.vantage-sme.de	500+	Munich	\N
556	Quantum AG	Healthcare	www.quantum-ag.de	18264	Hamburg	\N
558	Zenith Logistics	Manufacturing	www.zenith-logistics.de	18264	Hamburg	\N
562	Iron Logistics	Manufacturing	www.iron-logistics.de	18264	D�sseldorf	\N
563	Quantum Solutions	Construction	www.quantum-solutions.de	251-500	D�sseldorf	\N
564	Blue Harbor Solutions	Retail	www.blue-harbor-solutions.de	51-250	Munich	\N
569	Vantage GmbH	Retail	www.vantage-gmbh.de	251-500	Berlin	\N
574	Zenith Solutions	Healthcare	www.zenith-solutions.de	18264	Berlin	\N
576	Nexus AG	Manufacturing	www.nexus-ag.de	51-250	D�sseldorf	\N
577	Blue Harbor Digital	Logistics	www.blue-harbor-digital.de	500+	Frankfurt	\N
580	Zenith SME	Logistics	www.zenith-sme.de	251-500	Munich	\N
592	Quantum Solutions	Manufacturing	www.quantum-solutions.de	18264	Berlin	\N
596	Alpha Group	Healthcare	www.alpha-group.de	18264	Berlin	\N
600	Alpha AG	Construction	www.alpha-ag.de	500+	Stuttgart	\N
602	Iron Logistics	Healthcare	www.iron-logistics.de	18264	Stuttgart	\N
605	Peak AG	Manufacturing	www.peak-ag.de	18264	D�sseldorf	\N
606	Vantage Logistics	Manufacturing	www.vantage-logistics.de	18264	Stuttgart	\N
615	Vantage Digital	Healthcare	www.vantage-digital.de	51-250	D�sseldorf	\N
616	Quantum Digital	Finance	www.quantum-digital.de	51-250	Stuttgart	\N
619	Iron Group	Hospitality	www.iron-group.de	51-250	D�sseldorf	\N
622	Quantum Solutions	Retail	www.quantum-solutions.de	18264	Cologne	\N
625	Blue Harbor AG	Logistics	www.blue-harbor-ag.de	51-250	Stuttgart	\N
626	Zenith Logistics	Finance	www.zenith-logistics.de	251-500	Hamburg	\N
628	Alpha SME	Hospitality	www.alpha-sme.de	251-500	Hamburg	\N
629	Iron Group	Finance	www.iron-group.de	251-500	Cologne	\N
630	Nexus GmbH	Manufacturing	www.nexus-gmbh.de	251-500	Stuttgart	\N
631	Peak SME	Manufacturing	www.peak-sme.de	251-500	Munich	\N
635	Iron Digital	Logistics	www.iron-digital.de	18264	Stuttgart	\N
643	Quantum GmbH	Hospitality	www.quantum-gmbh.de	18264	Hamburg	\N
645	Zenith Logistics	Construction	www.zenith-logistics.de	500+	Berlin	\N
648	Zenith AG	Finance	www.zenith-ag.de	51-250	Munich	\N
653	Skyline Logistics	Construction	www.skyline-logistics.de	251-500	D�sseldorf	\N
662	Alpha AG	Retail	www.alpha-ag.de	51-250	Munich	\N
666	Alpha Digital	Healthcare	www.alpha-digital.de	251-500	Stuttgart	\N
669	Nexus Digital	Manufacturing	www.nexus-digital.de	18264	Berlin	\N
671	Iron AG	Manufacturing	www.iron-ag.de	500+	Frankfurt	\N
672	Alpha GmbH	Healthcare	www.alpha-gmbh.de	51-250	Berlin	\N
673	Iron Logistics	Healthcare	www.iron-logistics.de	500+	Frankfurt	\N
674	Iron AG	Manufacturing	www.iron-ag.de	18264	Munich	\N
676	Quantum Digital	Construction	www.quantum-digital.de	500+	Berlin	\N
679	Zenith Digital	Retail	www.zenith-digital.de	251-500	Hamburg	\N
681	Peak GmbH	Manufacturing	www.peak-gmbh.de	500+	D�sseldorf	\N
682	Nexus AG	Retail	www.nexus-ag.de	18264	D�sseldorf	\N
684	Nexus Solutions	Construction	www.nexus-solutions.de	251-500	Frankfurt	\N
690	Skyline AG	Retail	www.skyline-ag.de	18264	D�sseldorf	\N
695	Iron Digital	Healthcare	www.iron-digital.de	18264	Berlin	\N
697	Quantum Group	Hospitality	www.quantum-group.de	18264	Berlin	\N
701	Peak Group	Manufacturing	www.peak-group.de	251-500	Stuttgart	\N
706	Skyline Solutions	Construction	www.skyline-solutions.de	500+	Hamburg	\N
709	Blue Harbor Group	Finance	www.blue-harbor-group.de	251-500	Frankfurt	\N
715	Zenith AG	Healthcare	www.zenith-ag.de	500+	Stuttgart	\N
718	Zenith Logistics	Retail	www.zenith-logistics.de	51-250	Cologne	\N
719	Vantage Solutions	Finance	www.vantage-solutions.de	51-250	Stuttgart	\N
724	Quantum GmbH	Construction	www.quantum-gmbh.de	500+	Stuttgart	\N
727	Nexus Logistics	Hospitality	www.nexus-logistics.de	500+	Cologne	\N
728	Iron GmbH	Retail	www.iron-gmbh.de	18264	D�sseldorf	\N
732	Vantage Digital	Construction	www.vantage-digital.de	500+	Hamburg	\N
733	Vantage Solutions	Retail	www.vantage-solutions.de	51-250	Berlin	\N
734	Skyline GmbH	Manufacturing	www.skyline-gmbh.de	18264	D�sseldorf	\N
735	Iron SME	Manufacturing	www.iron-sme.de	51-250	Munich	\N
739	Alpha AG	Manufacturing	www.alpha-ag.de	500+	Frankfurt	\N
745	Zenith SME	Finance	www.zenith-sme.de	251-500	D�sseldorf	\N
747	Blue Harbor AG	Finance	www.blue-harbor-ag.de	500+	Cologne	\N
748	Alpha GmbH	Manufacturing	www.alpha-gmbh.de	18264	Stuttgart	\N
750	Vantage AG	Construction	www.vantage-ag.de	500+	Hamburg	\N
753	Quantum AG	Finance	www.quantum-ag.de	51-250	Hamburg	\N
757	Peak AG	Retail	www.peak-ag.de	500+	Berlin	\N
760	Skyline Digital	Healthcare	www.skyline-digital.de	51-250	Munich	\N
768	Zenith Digital	Hospitality	www.zenith-digital.de	18264	Stuttgart	\N
770	Zenith Solutions	Retail	www.zenith-solutions.de	51-250	Hamburg	\N
773	Vantage SME	Construction	www.vantage-sme.de	500+	Berlin	\N
775	Blue Harbor Logistics	Finance	www.blue-harbor-logistics.de	251-500	Munich	\N
778	Zenith AG	Finance	www.zenith-ag.de	51-250	Hamburg	\N
781	Blue Harbor Solutions	Retail	www.blue-harbor-solutions.de	500+	Berlin	\N
782	Quantum Logistics	Construction	www.quantum-logistics.de	18264	Stuttgart	\N
783	Vantage GmbH	Construction	www.vantage-gmbh.de	18264	Munich	\N
788	Quantum Group	Retail	www.quantum-group.de	51-250	Berlin	\N
789	Nexus Digital	Hospitality	www.nexus-digital.de	500+	Hamburg	\N
797	Peak Group	Construction	www.peak-group.de	51-250	Berlin	\N
799	Vantage AG	Construction	www.vantage-ag.de	18264	Munich	\N
803	Zenith Logistics	Logistics	www.zenith-logistics.de	51-250	Hamburg	\N
809	Quantum GmbH	Logistics	www.quantum-gmbh.de	51-250	D�sseldorf	\N
826	Vantage Digital	Construction	www.vantage-digital.de	51-250	Stuttgart	\N
828	Nexus Solutions	Manufacturing	www.nexus-solutions.de	500+	Stuttgart	\N
830	Skyline Logistics	Construction	www.skyline-logistics.de	18264	Berlin	\N
835	Quantum Solutions	Manufacturing	www.quantum-solutions.de	51-250	Stuttgart	\N
836	Iron Digital	Retail	www.iron-digital.de	500+	Cologne	\N
837	Iron Digital	Manufacturing	www.iron-digital.de	500+	Frankfurt	\N
841	Vantage Solutions	Healthcare	www.vantage-solutions.de	51-250	D�sseldorf	\N
844	Blue Harbor SME	Logistics	www.blue-harbor-sme.de	500+	Cologne	\N
845	Zenith Logistics	Healthcare	www.zenith-logistics.de	500+	Munich	\N
846	Nexus Logistics	Retail	www.nexus-logistics.de	500+	Hamburg	\N
847	Quantum Solutions	Hospitality	www.quantum-solutions.de	500+	Berlin	\N
849	Peak AG	Finance	www.peak-ag.de	251-500	Munich	\N
852	Alpha AG	Retail	www.alpha-ag.de	500+	Berlin	\N
857	Zenith GmbH	Finance	www.zenith-gmbh.de	51-250	Berlin	\N
858	Nexus Logistics	Healthcare	www.nexus-logistics.de	18264	D�sseldorf	\N
859	Blue Harbor Digital	Hospitality	www.blue-harbor-digital.de	51-250	Hamburg	\N
860	Quantum SME	Logistics	www.quantum-sme.de	251-500	Munich	\N
862	Vantage Digital	Manufacturing	www.vantage-digital.de	500+	Cologne	\N
865	Skyline Group	Healthcare	www.skyline-group.de	51-250	Hamburg	\N
872	Vantage Group	Manufacturing	www.vantage-group.de	251-500	Berlin	\N
873	Peak Logistics	Retail	www.peak-logistics.de	251-500	Frankfurt	\N
876	Vantage Solutions	Retail	www.vantage-solutions.de	18264	Frankfurt	\N
877	Blue Harbor Logistics	Construction	www.blue-harbor-logistics.de	251-500	Hamburg	\N
880	Quantum GmbH	Hospitality	www.quantum-gmbh.de	18264	Cologne	\N
882	Skyline Logistics	Manufacturing	www.skyline-logistics.de	500+	Stuttgart	\N
884	Skyline Group	Manufacturing	www.skyline-group.de	500+	Hamburg	\N
886	Peak Digital	Manufacturing	www.peak-digital.de	51-250	Cologne	\N
888	Iron SME	Retail	www.iron-sme.de	500+	Stuttgart	\N
889	Vantage Solutions	Healthcare	www.vantage-solutions.de	251-500	Frankfurt	\N
891	Zenith Digital	Manufacturing	www.zenith-digital.de	251-500	D�sseldorf	\N
894	Blue Harbor Logistics	Retail	www.blue-harbor-logistics.de	251-500	Cologne	\N
898	Iron AG	Healthcare	www.iron-ag.de	51-250	Berlin	\N
903	Peak Logistics	Hospitality	www.peak-logistics.de	18264	Berlin	\N
905	Skyline Group	Finance	www.skyline-group.de	251-500	Stuttgart	\N
908	Alpha Digital	Finance	www.alpha-digital.de	18264	Hamburg	\N
909	Blue Harbor Digital	Retail	www.blue-harbor-digital.de	51-250	D�sseldorf	\N
910	Zenith Logistics	Logistics	www.zenith-logistics.de	500+	Frankfurt	\N
911	Quantum GmbH	Retail	www.quantum-gmbh.de	18264	Cologne	\N
927	Vantage Logistics	Healthcare	www.vantage-logistics.de	500+	Hamburg	\N
928	Alpha SME	Retail	www.alpha-sme.de	500+	Stuttgart	\N
931	Zenith Logistics	Construction	www.zenith-logistics.de	18264	Frankfurt	\N
932	Zenith Group	Healthcare	www.zenith-group.de	500+	Cologne	\N
933	Zenith GmbH	Finance	www.zenith-gmbh.de	51-250	Cologne	\N
937	Skyline Solutions	Healthcare	www.skyline-solutions.de	500+	Munich	\N
943	Quantum SME	Construction	www.quantum-sme.de	500+	Berlin	\N
944	Nexus Logistics	Retail	www.nexus-logistics.de	251-500	Munich	\N
950	Zenith AG	Logistics	www.zenith-ag.de	18264	Hamburg	\N
953	Iron Logistics	Construction	www.iron-logistics.de	51-250	D�sseldorf	\N
963	Iron AG	Finance	www.iron-ag.de	251-500	Munich	\N
964	Skyline Group	Manufacturing	www.skyline-group.de	251-500	Cologne	\N
967	Skyline Logistics	Finance	www.skyline-logistics.de	251-500	Cologne	\N
969	Vantage Digital	Hospitality	www.vantage-digital.de	251-500	Frankfurt	\N
972	Quantum GmbH	Construction	www.quantum-gmbh.de	51-250	Cologne	\N
975	Nexus GmbH	Retail	www.nexus-gmbh.de	251-500	Munich	\N
976	Vantage Logistics	Construction	www.vantage-logistics.de	500+	Stuttgart	\N
979	Blue Harbor Logistics	Manufacturing	www.blue-harbor-logistics.de	500+	Munich	\N
982	Zenith Digital	Manufacturing	www.zenith-digital.de	500+	Stuttgart	\N
989	Zenith SME	Manufacturing	www.zenith-sme.de	51-250	Stuttgart	\N
997	Nexus GmbH	Finance	www.nexus-gmbh.de	251-500	Stuttgart	\N
999	Iron Logistics	Healthcare	www.iron-logistics.de	51-250	Frankfurt	\N
1000	Nexus Digital	Healthcare	www.nexus-digital.de	51-250	D�sseldorf	\N
1003	Blue Harbor Group	Finance	www.blue-harbor-group.de	18264	Berlin	\N
1004	Iron Group	Hospitality	www.iron-group.de	18264	Frankfurt	\N
1005	Nexus SME	Retail	www.nexus-sme.de	251-500	Stuttgart	\N
1012	Iron GmbH	Healthcare	www.iron-gmbh.de	251-500	Frankfurt	\N
1015	Zenith Logistics	Finance	www.zenith-logistics.de	500+	Cologne	\N
1016	Blue Harbor Logistics	Retail	www.blue-harbor-logistics.de	500+	Frankfurt	\N
1018	Skyline GmbH	Finance	www.skyline-gmbh.de	500+	Stuttgart	\N
1021	Quantum Logistics	Manufacturing	www.quantum-logistics.de	18264	Hamburg	\N
1023	Blue Harbor Logistics	Logistics	www.blue-harbor-logistics.de	51-250	Frankfurt	\N
1024	Blue Harbor Group	Finance	www.blue-harbor-group.de	51-250	Hamburg	\N
1025	Iron GmbH	Manufacturing	www.iron-gmbh.de	18264	Hamburg	\N
1032	Alpha SME	Healthcare	www.alpha-sme.de	51-250	Hamburg	\N
1037	Zenith GmbH	Healthcare	www.zenith-gmbh.de	500+	Frankfurt	\N
1044	Zenith GmbH	Finance	www.zenith-gmbh.de	251-500	Hamburg	\N
1045	Quantum Group	Construction	www.quantum-group.de	500+	Cologne	\N
1050	Zenith Solutions	Construction	www.zenith-solutions.de	251-500	D�sseldorf	\N
1052	Quantum Logistics	Manufacturing	www.quantum-logistics.de	500+	D�sseldorf	\N
1056	Peak Digital	Finance	www.peak-digital.de	500+	Munich	\N
1057	Skyline Digital	Retail	www.skyline-digital.de	18264	Frankfurt	\N
1058	Quantum AG	Manufacturing	www.quantum-ag.de	51-250	Munich	\N
1064	Iron Logistics	Manufacturing	www.iron-logistics.de	18264	Stuttgart	\N
1072	Nexus Logistics	Logistics	www.nexus-logistics.de	18264	Frankfurt	\N
1075	Blue Harbor SME	Retail	www.blue-harbor-sme.de	18264	Munich	\N
1076	Zenith Group	Hospitality	www.zenith-group.de	500+	Hamburg	\N
1083	Nexus Group	Logistics	www.nexus-group.de	51-250	D�sseldorf	\N
1086	Blue Harbor Solutions	Finance	www.blue-harbor-solutions.de	251-500	D�sseldorf	\N
1088	Zenith Digital	Logistics	www.zenith-digital.de	251-500	Cologne	\N
1090	Zenith Logistics	Manufacturing	www.zenith-logistics.de	18264	Hamburg	\N
1091	Alpha Digital	Construction	www.alpha-digital.de	500+	D�sseldorf	\N
1092	Blue Harbor SME	Finance	www.blue-harbor-sme.de	251-500	Munich	\N
1095	Quantum AG	Construction	www.quantum-ag.de	18264	Hamburg	\N
1100	Vantage Digital	Retail	www.vantage-digital.de	51-250	D�sseldorf	\N
1101	Quantum Digital	Construction	www.quantum-digital.de	251-500	Frankfurt	\N
1102	Zenith AG	Construction	www.zenith-ag.de	51-250	Cologne	\N
1103	Blue Harbor Digital	Finance	www.blue-harbor-digital.de	251-500	Hamburg	\N
1104	Iron GmbH	Finance	www.iron-gmbh.de	51-250	Munich	\N
1110	Vantage Group	Healthcare	www.vantage-group.de	500+	Frankfurt	\N
1116	Peak GmbH	Logistics	www.peak-gmbh.de	51-250	D�sseldorf	\N
1118	Alpha Solutions	Hospitality	www.alpha-solutions.de	251-500	Frankfurt	\N
1119	Peak Solutions	Construction	www.peak-solutions.de	51-250	Hamburg	\N
1121	Alpha Group	Logistics	www.alpha-group.de	251-500	Hamburg	\N
1123	Iron Solutions	Logistics	www.iron-solutions.de	251-500	Berlin	\N
1125	Peak AG	Healthcare	www.peak-ag.de	500+	D�sseldorf	\N
1126	Vantage SME	Finance	www.vantage-sme.de	51-250	Stuttgart	\N
1127	Quantum Solutions	Retail	www.quantum-solutions.de	251-500	Frankfurt	\N
1128	Iron Group	Retail	www.iron-group.de	251-500	Munich	\N
1130	Peak Logistics	Finance	www.peak-logistics.de	18264	Munich	\N
1132	Peak SME	Construction	www.peak-sme.de	251-500	Munich	\N
1138	Skyline SME	Healthcare	www.skyline-sme.de	18264	D�sseldorf	\N
1139	Vantage GmbH	Logistics	www.vantage-gmbh.de	18264	Munich	\N
1144	Alpha AG	Retail	www.alpha-ag.de	500+	Munich	\N
1146	Blue Harbor Logistics	Healthcare	www.blue-harbor-logistics.de	51-250	D�sseldorf	\N
1152	Iron Group	Construction	www.iron-group.de	18264	Berlin	\N
1157	Alpha Solutions	Logistics	www.alpha-solutions.de	251-500	Stuttgart	\N
1158	Vantage AG	Construction	www.vantage-ag.de	18264	D�sseldorf	\N
1170	Iron SME	Manufacturing	www.iron-sme.de	51-250	Berlin	\N
1171	Alpha SME	Construction	www.alpha-sme.de	500+	Munich	\N
1172	Skyline Solutions	Hospitality	www.skyline-solutions.de	251-500	D�sseldorf	\N
1175	Alpha Logistics	Hospitality	www.alpha-logistics.de	251-500	Frankfurt	\N
1177	Vantage GmbH	Healthcare	www.vantage-gmbh.de	251-500	Hamburg	\N
1189	Alpha Logistics	Finance	www.alpha-logistics.de	18264	Cologne	\N
1191	Iron Logistics	Retail	www.iron-logistics.de	18264	Berlin	\N
1192	Peak Logistics	Healthcare	www.peak-logistics.de	500+	Munich	\N
1197	Nexus Group	Finance	www.nexus-group.de	251-500	D�sseldorf	\N
1199	Alpha AG	Finance	www.alpha-ag.de	251-500	Stuttgart	\N
1201	Blue Harbor Digital	Logistics	www.blue-harbor-digital.de	500+	Stuttgart	\N
1202	Zenith Solutions	Hospitality	www.zenith-solutions.de	51-250	Munich	\N
1203	Nexus Solutions	Finance	www.nexus-solutions.de	18264	Cologne	\N
1204	Skyline GmbH	Manufacturing	www.skyline-gmbh.de	18264	Stuttgart	\N
1211	Peak Group	Logistics	www.peak-group.de	18264	Hamburg	\N
1216	Zenith Digital	Hospitality	www.zenith-digital.de	51-250	Berlin	\N
1218	Vantage GmbH	Retail	www.vantage-gmbh.de	500+	Munich	\N
1221	Nexus GmbH	Construction	www.nexus-gmbh.de	51-250	Hamburg	\N
1225	Zenith Group	Logistics	www.zenith-group.de	500+	D�sseldorf	\N
1230	Nexus Solutions	Logistics	www.nexus-solutions.de	18264	Munich	\N
1234	Skyline Digital	Finance	www.skyline-digital.de	18264	Munich	\N
1237	Nexus Group	Finance	www.nexus-group.de	51-250	Frankfurt	\N
1241	Peak Group	Logistics	www.peak-group.de	500+	Berlin	\N
1248	Peak SME	Construction	www.peak-sme.de	251-500	Stuttgart	\N
1254	Vantage Digital	Logistics	www.vantage-digital.de	251-500	Hamburg	\N
1255	Alpha Solutions	Healthcare	www.alpha-solutions.de	18264	Stuttgart	\N
1257	Nexus SME	Construction	www.nexus-sme.de	500+	Munich	\N
1259	Iron AG	Healthcare	www.iron-ag.de	251-500	Stuttgart	\N
1261	Peak SME	Construction	www.peak-sme.de	500+	Berlin	\N
1263	Peak Group	Construction	www.peak-group.de	51-250	Cologne	\N
1264	Vantage Logistics	Manufacturing	www.vantage-logistics.de	51-250	D�sseldorf	\N
1265	Peak GmbH	Retail	www.peak-gmbh.de	251-500	Frankfurt	\N
1266	Iron Digital	Finance	www.iron-digital.de	251-500	Hamburg	\N
1270	Quantum GmbH	Construction	www.quantum-gmbh.de	18264	Berlin	\N
1272	Nexus Digital	Logistics	www.nexus-digital.de	500+	Stuttgart	\N
1273	Vantage SME	Construction	www.vantage-sme.de	51-250	D�sseldorf	\N
1279	Iron Group	Manufacturing	www.iron-group.de	18264	Cologne	\N
1283	Peak AG	Retail	www.peak-ag.de	500+	Hamburg	\N
1286	Zenith Solutions	Manufacturing	www.zenith-solutions.de	251-500	Cologne	\N
1288	Iron Group	Manufacturing	www.iron-group.de	18264	Munich	\N
1289	Quantum SME	Hospitality	www.quantum-sme.de	51-250	Frankfurt	\N
1290	Zenith Logistics	Retail	www.zenith-logistics.de	251-500	Hamburg	\N
1292	Zenith Solutions	Manufacturing	www.zenith-solutions.de	251-500	Frankfurt	\N
1293	Iron SME	Finance	www.iron-sme.de	18264	Cologne	\N
1294	Peak AG	Construction	www.peak-ag.de	18264	Stuttgart	\N
1297	Zenith Logistics	Logistics	www.zenith-logistics.de	500+	D�sseldorf	\N
1298	Alpha Logistics	Hospitality	www.alpha-logistics.de	500+	Frankfurt	\N
1299	Zenith AG	Manufacturing	www.zenith-ag.de	18264	Munich	\N
1301	Quantum Digital	Hospitality	www.quantum-digital.de	18264	Hamburg	\N
1304	Iron Logistics	Hospitality	www.iron-logistics.de	18264	Frankfurt	\N
1315	Vantage Solutions	Healthcare	www.vantage-solutions.de	51-250	Berlin	\N
1317	Blue Harbor Solutions	Hospitality	www.blue-harbor-solutions.de	18264	D�sseldorf	\N
1323	Vantage AG	Logistics	www.vantage-ag.de	500+	D�sseldorf	\N
1324	Alpha SME	Finance	www.alpha-sme.de	251-500	Cologne	\N
1326	Quantum Logistics	Hospitality	www.quantum-logistics.de	500+	Cologne	\N
1328	Iron Solutions	Finance	www.iron-solutions.de	500+	Munich	\N
1337	Skyline Group	Construction	www.skyline-group.de	51-250	Frankfurt	\N
1338	Vantage Solutions	Manufacturing	www.vantage-solutions.de	51-250	Frankfurt	\N
1339	Zenith AG	Healthcare	www.zenith-ag.de	18264	Munich	\N
1341	Quantum Group	Manufacturing	www.quantum-group.de	500+	Munich	\N
1342	Nexus GmbH	Healthcare	www.nexus-gmbh.de	500+	Hamburg	\N
1345	Skyline AG	Hospitality	www.skyline-ag.de	251-500	D�sseldorf	\N
1349	Blue Harbor AG	Construction	www.blue-harbor-ag.de	18264	Frankfurt	\N
1352	Zenith Logistics	Finance	www.zenith-logistics.de	51-250	Berlin	\N
1354	Peak AG	Hospitality	www.peak-ag.de	500+	Munich	\N
1357	Alpha Group	Logistics	www.alpha-group.de	18264	Frankfurt	\N
1358	Iron Logistics	Finance	www.iron-logistics.de	18264	Stuttgart	\N
1363	Nexus GmbH	Manufacturing	www.nexus-gmbh.de	500+	Stuttgart	\N
1367	Vantage SME	Finance	www.vantage-sme.de	51-250	Cologne	\N
1368	Iron GmbH	Finance	www.iron-gmbh.de	251-500	Cologne	\N
1369	Nexus SME	Logistics	www.nexus-sme.de	18264	Hamburg	\N
1373	Blue Harbor SME	Manufacturing	www.blue-harbor-sme.de	51-250	Stuttgart	\N
1377	Alpha Logistics	Construction	www.alpha-logistics.de	51-250	D�sseldorf	\N
1378	Zenith Group	Finance	www.zenith-group.de	18264	Stuttgart	\N
1381	Skyline SME	Construction	www.skyline-sme.de	500+	Berlin	\N
1391	Quantum Logistics	Retail	www.quantum-logistics.de	51-250	Hamburg	\N
1392	Skyline SME	Hospitality	www.skyline-sme.de	51-250	Cologne	\N
1393	Iron GmbH	Retail	www.iron-gmbh.de	251-500	Hamburg	\N
1399	Quantum SME	Logistics	www.quantum-sme.de	500+	Berlin	\N
1406	Iron Digital	Manufacturing	www.iron-digital.de	18264	Berlin	\N
1409	Skyline SME	Healthcare	www.skyline-sme.de	51-250	D�sseldorf	\N
1412	Nexus Solutions	Retail	www.nexus-solutions.de	18264	Hamburg	\N
1414	Alpha Digital	Healthcare	www.alpha-digital.de	251-500	Berlin	\N
1416	Nexus Solutions	Finance	www.nexus-solutions.de	51-250	Berlin	\N
1419	Vantage AG	Manufacturing	www.vantage-ag.de	18264	Cologne	\N
1422	Vantage Group	Manufacturing	www.vantage-group.de	51-250	Berlin	\N
1423	Alpha GmbH	Hospitality	www.alpha-gmbh.de	51-250	Hamburg	\N
1430	Iron SME	Manufacturing	www.iron-sme.de	51-250	Hamburg	\N
1431	Blue Harbor Digital	Retail	www.blue-harbor-digital.de	500+	D�sseldorf	\N
1435	Zenith Solutions	Hospitality	www.zenith-solutions.de	18264	D�sseldorf	\N
1437	Nexus Logistics	Manufacturing	www.nexus-logistics.de	251-500	Stuttgart	\N
1442	Iron GmbH	Logistics	www.iron-gmbh.de	18264	Munich	\N
1444	Skyline AG	Hospitality	www.skyline-ag.de	51-250	Frankfurt	\N
1445	Peak Group	Logistics	www.peak-group.de	251-500	Hamburg	\N
1447	Skyline SME	Construction	www.skyline-sme.de	51-250	Munich	\N
1448	Alpha Group	Construction	www.alpha-group.de	251-500	Munich	\N
1451	Iron Digital	Finance	www.iron-digital.de	51-250	Munich	\N
1452	Iron Solutions	Finance	www.iron-solutions.de	500+	Stuttgart	\N
1460	Nexus Logistics	Retail	www.nexus-logistics.de	51-250	D�sseldorf	\N
1462	Zenith SME	Hospitality	www.zenith-sme.de	251-500	D�sseldorf	\N
1467	Blue Harbor AG	Healthcare	www.blue-harbor-ag.de	500+	Frankfurt	\N
1472	Alpha Logistics	Hospitality	www.alpha-logistics.de	500+	Frankfurt	\N
1475	Peak GmbH	Healthcare	www.peak-gmbh.de	500+	Berlin	\N
1482	Alpha SME	Construction	www.alpha-sme.de	251-500	Frankfurt	\N
1486	Iron Logistics	Construction	www.iron-logistics.de	18264	Berlin	\N
1488	Blue Harbor SME	Healthcare	www.blue-harbor-sme.de	18264	D�sseldorf	\N
1489	Skyline AG	Hospitality	www.skyline-ag.de	251-500	Stuttgart	\N
4	Hamza Corp	Technology	http://hamzalatif.com	1-10	Berlin	hamzi207@gmail.com
\.


--
-- Data for Name: dimensions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dimensions (dimension_id, dimension_name, dimension_weight) FROM stdin;
1	Strategy & Business Vision	25
2	People & Culture	15.5
3	Data Readiness & Literacy	18.5
4	Use Cases & Business Value	15.5
5	Processes & Scaling	16
6	Governance & Compliance	15.5
7	Tech Infrastructure	9.5
8	General Psychology	0
\.


--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.questions (question_id, dimension_id, header, question_text, type, weight, optional) FROM stdin;
1	1	Leadership Alignment	How is AI prioritized in management meetings?	Statement	4.5	f
2	1	Clarity	Does a documented AI strategy or roadmap exist?	Slider	4.5	f
3	1	Budget Allocation	How is AI funding and investment handled?	Choice	4	f
4	1	Competitive Ambition	What is your goal regarding AI vs. competitors?	Choice	3.5	f
5	2	AI Mindset	How do employees generally react to the topic of AI?	Slider	4	f
6	2	AI Competencies	To what extent are AI capabilities and technical literacy established across your workforce? E.g. expertise in machine learning and NLP, as well as general AI literacy for non-technical staff.	Statement	4.5	f
7	2	Training Program	How often do employees receive AI training?	Choice	3	f
8	2	Psychological Safety	Is it "okay" to fail with an AI pilot project?	Slider	4	f
9	3	Data types	What types of business data do you actively collect? (Select all that apply)	Checklist	4	f
10	3	Data Centralization	Do you currently use any of these technologies? (Select all that apply)	Checklist	3	f
11	3	Data Quality	Describe the "cleanliness" of your business data.	Slider	4	f
12	3	Staff Proficiency	How comfortable is your team with data insights?	Choice	3.5	f
13	4	AI Feasibility	How rigorously does your organization validate the technical and regulatory feasibility of an AI use case before committing resources?	Statement	4	f
14	4	Current Activity	How many AI use cases are currently active?	Slider	3	f
15	4	ROI Tracking	Do you measure the financial impact of AI projects?	Choice	4	f
16	4	Strategic Priority	To what extent does AI address concrete bottlenecks in your core business operations rather than experimental topics?\n	Statement	4.5	f
17	5	Standardization	Are core processes documented and repeatable?	Choice	4.5	f
18	5	Execution Maturity	How structured is your approach to planning, implementing, and delivering AI-related projects?\n	Statement	4.5	f
19	5	Execution Speed	How long to implement a new digital tool?	Slider	3.5	f
20	5	Scaling Capability	Is there a defined path to move AI idea to production?	Choice	3.5	f
21	6	Guidelines	Do you have an internal "AI Code of Conduct"?	Choice	3	f
22	6	Data Privacy	How strictly is data handled according to the EU AI Act?	Slider	3.5	f
23	6	Accountability	Who is responsible for AI outcomes and errors?	Choice	3	f
24	6	Transparency	What disclosure requirements exist for external partners?	Choice	3	f
25	7	Cloud Readiness	To what extent do you use Cloud infrastructure?	Slider	3	f
26	7	AI Tooling Stack	What types of AI development tools are currently available in your organization? (Select all that apply)	Checklist	3.5	f
27	7	IT Scalability	How easily can you scale new software company-wide?	Slider	3	f
28	8	Motivation	Why are you doing this AI assessment?	Statement	0	t
29	8	Business Priorities	Which business challenge is your top priority? (Select all that apply)	Checklist	0	t
30	8	Strategic Impact	How is AI influencing your organization�s strategy?	Choice	0	t
31	8	AI Ownership	Who is the primary driver of AI  within your organization? (Select all that apply)	Checklist	0	t
32	8	Responsibility	Are you in charge of AI initiatives?	Choice	0	t
33	8	Role & Seniority	Which option best describes your position and decision authority? (Select all that apply)	Checklist	0	t
\.


--
-- Data for Name: response_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.response_items (item_id, response_id, question_id, answers) FROM stdin;
1	1	1	{2}
2	1	2	{6}
3	1	3	{11}
4	1	4	{16}
5	1	5	{21}
6	1	6	{26}
7	1	7	{31}
8	1	8	{36}
9	1	9	{43}
10	1	10	{54,50,51}
11	1	11	{57}
12	1	12	{63}
13	1	13	{67}
14	1	14	{72}
15	1	15	{77}
16	1	16	{83}
17	1	17	{88}
18	1	18	{96}
19	1	19	{98}
20	1	20	{102}
21	1	21	{108}
22	1	22	{112}
23	1	23	{117}
24	1	24	{122}
25	1	25	{127}
26	1	26	{135,136}
27	1	27	{138}
28	1	28	{143}
29	1	29	{153}
30	1	30	{157}
31	1	31	{162}
32	1	32	{170}
33	1	33	{173}
34	2	1	{1}
35	2	2	{6}
36	2	3	{11}
37	2	4	{16}
38	2	5	{21}
39	2	6	{26}
40	2	7	{31}
41	2	8	{36}
42	2	9	{42,44,41}
43	2	10	{53}
44	2	11	{57}
45	2	12	{62}
46	2	13	{67}
47	2	14	{72}
48	2	15	{77}
49	2	16	{83}
50	2	17	{87}
51	2	18	{93}
52	2	19	{97}
53	2	20	{102}
54	2	21	{109}
55	2	22	{112}
56	2	23	{121}
57	2	24	{122}
58	2	25	{127}
59	2	26	{134,136,137}
60	2	27	{139}
61	2	28	{143}
62	2	29	{148,152,150}
63	2	30	{158}
64	2	31	{161,162,169}
65	2	32	{171}
66	2	33	{175,174}
67	3	1	{1}
68	3	2	{6}
69	3	3	{11}
70	3	4	{16}
71	3	5	{21}
72	3	6	{26}
73	3	7	{31}
74	3	8	{36}
75	3	9	{44,41}
76	3	10	{50,51,56}
77	3	11	{57}
78	3	12	{62}
79	3	13	{67}
80	3	14	{75}
81	3	15	{77}
82	3	16	{83}
83	3	17	{87}
84	3	18	{92}
85	3	19	{97}
86	3	20	{102}
87	3	21	{108}
88	3	22	{112}
89	3	23	{118}
90	3	24	{122}
91	3	25	{127}
92	3	26	{136}
93	3	27	{139}
94	3	28	{144}
95	3	29	{152,150,149}
96	3	30	{160}
97	3	31	{162}
98	3	32	{172}
99	3	33	{179,177}
100	4	1	{1}
101	4	2	{6}
102	4	3	{11}
103	4	4	{19}
104	4	5	{21}
105	4	6	{26}
106	4	7	{31}
107	4	8	{36}
108	4	9	{42,47}
109	4	10	{49}
110	4	11	{59}
111	4	12	{66}
112	4	13	{67}
113	4	14	{73}
114	4	15	{77}
115	4	16	{83}
116	4	17	{87}
117	4	18	{92}
118	4	19	{99}
119	4	20	{106}
120	4	21	{108}
121	4	22	{112}
122	4	23	{119}
123	4	24	{122}
124	4	25	{127}
125	4	26	{136,137}
126	4	27	{138}
127	4	28	{143}
128	4	29	{148,150}
129	4	30	{159}
130	4	31	{161,164}
131	4	32	{170}
132	4	33	{177}
133	5	1	{1}
134	5	2	{7}
135	5	3	{11}
136	5	4	{16}
137	5	5	{21}
138	5	6	{26}
139	5	7	{31}
140	5	8	{36}
141	5	9	{48,46,41}
142	5	10	{51}
143	5	11	{58}
144	5	12	{62}
145	5	13	{68}
146	5	14	{73}
147	5	15	{77}
148	5	16	{82}
149	5	17	{87}
150	5	18	{92}
151	5	19	{97}
152	5	20	{103}
153	5	21	{111}
154	5	22	{112}
155	5	23	{117}
156	5	24	{123}
157	5	25	{128}
158	5	26	{136}
159	5	27	{138}
160	5	28	{143}
161	5	29	{150}
162	5	30	{158}
163	5	31	{166,165}
164	5	32	{170}
165	5	33	{178,181,180}
166	6	1	{1}
167	6	2	{6}
168	6	3	{11}
169	6	4	{19}
170	6	5	{21}
171	6	6	{26}
172	6	7	{32}
173	6	8	{36}
174	6	9	{48,43,41}
175	6	10	{49}
176	6	11	{57}
177	6	12	{65}
178	6	13	{67}
179	6	14	{73}
180	6	15	{78}
181	6	16	{83}
182	6	17	{87}
183	6	18	{92}
184	6	19	{97}
185	6	20	{104}
186	6	21	{108}
187	6	22	{112}
188	6	23	{120}
189	6	24	{122}
190	6	25	{128}
191	6	26	{137}
192	6	27	{138}
193	6	28	{143}
194	6	29	{150}
195	6	30	{159}
196	6	31	{167}
197	6	32	{172}
198	6	33	{176,175}
199	7	1	{1}
200	7	2	{6}
201	7	3	{12}
202	7	4	{16}
203	7	5	{22}
204	7	6	{26}
205	7	7	{31}
206	7	8	{36}
207	7	9	{47}
208	7	10	{56}
209	7	11	{57}
210	7	12	{62}
211	7	13	{67}
212	7	14	{73}
213	7	15	{77}
214	7	16	{82}
215	7	17	{87}
216	7	18	{92}
217	7	19	{97}
218	7	20	{102}
219	7	21	{108}
220	7	22	{112}
221	7	23	{117}
222	7	24	{122}
223	7	25	{127}
224	7	26	{132,135,134}
225	7	27	{139}
226	7	28	{143}
227	7	29	{148,154}
228	7	30	{157}
229	7	31	{169}
230	7	32	{171}
231	7	33	{176,177}
232	8	1	{2}
233	8	2	{6}
234	8	3	{12}
235	8	4	{16}
236	8	5	{21}
237	8	6	{26}
238	8	7	{32}
239	8	8	{36}
240	8	9	{44}
241	8	10	{50,51}
242	8	11	{57}
243	8	12	{62}
244	8	13	{67}
245	8	14	{72}
246	8	15	{77}
247	8	16	{86}
248	8	17	{87}
249	8	18	{92}
250	8	19	{97}
251	8	20	{102}
252	8	21	{108}
253	8	22	{112}
254	8	23	{117}
255	8	24	{123}
256	8	25	{129}
257	8	26	{133}
258	8	27	{138}
259	8	28	{144}
260	8	29	{154}
261	8	30	{158}
262	8	31	{164}
263	8	32	{170}
264	8	33	{180}
265	9	1	{1}
266	9	2	{6}
267	9	3	{11}
268	9	4	{17}
269	9	5	{22}
270	9	6	{26}
271	9	7	{32}
272	9	8	{37}
273	9	9	{48}
274	9	10	{53,50}
275	9	11	{59}
276	9	12	{62}
277	9	13	{68}
278	9	14	{72}
279	9	15	{77}
280	9	16	{83}
281	9	17	{91}
282	9	18	{92}
283	9	19	{98}
284	9	20	{102}
285	9	21	{109}
286	9	22	{113}
287	9	23	{117}
288	9	24	{122}
289	9	25	{127}
290	9	26	{136}
291	9	27	{139}
292	9	28	{143}
293	9	29	{154}
294	9	30	{159}
295	9	31	{164}
296	9	32	{170}
297	9	33	{180,174}
298	10	1	{5}
299	10	2	{7}
300	10	3	{11}
301	10	4	{16}
302	10	5	{21}
303	10	6	{26}
304	10	7	{31}
305	10	8	{36}
306	10	9	{42,46,41}
307	10	10	{54}
308	10	11	{61}
309	10	12	{62}
310	10	13	{67}
311	10	14	{72}
312	10	15	{77}
313	10	16	{82}
314	10	17	{87}
315	10	18	{92}
316	10	19	{97}
317	10	20	{102}
318	10	21	{108}
319	10	22	{112}
320	10	23	{118}
321	10	24	{122}
322	10	25	{128}
323	10	26	{133,135,136}
324	10	27	{139}
325	10	28	{147}
326	10	29	{151,154}
327	10	30	{159}
328	10	31	{163}
329	10	32	{172}
330	10	33	{174,173}
331	11	1	{2}
332	11	2	{7}
333	11	3	{11}
334	11	4	{16}
335	11	5	{21}
336	11	6	{26}
337	11	7	{31}
338	11	8	{36}
339	11	9	{42,44,45}
340	11	10	{49}
341	11	11	{57}
342	11	12	{62}
343	11	13	{67}
344	11	14	{72}
345	11	15	{77}
346	11	16	{82}
347	11	17	{87}
348	11	18	{92}
349	11	19	{97}
350	11	20	{102}
351	11	21	{108}
352	11	22	{116}
353	11	23	{117}
354	11	24	{123}
355	11	25	{127}
356	11	26	{132,136}
357	11	27	{138}
358	11	28	{143}
359	11	29	{151,148,150}
360	11	30	{159}
361	11	31	{166,162,169}
362	11	32	{172}
363	11	33	{179,177}
364	12	1	{1}
365	12	2	{6}
366	12	3	{11}
367	12	4	{17}
368	12	5	{21}
369	12	6	{27}
370	12	7	{32}
371	12	8	{36}
372	12	9	{48,46,43}
373	12	10	{50,51,56}
374	12	11	{57}
375	12	12	{62}
376	12	13	{68}
377	12	14	{72}
378	12	15	{77}
379	12	16	{82}
380	12	17	{87}
381	12	18	{92}
382	12	19	{98}
383	12	20	{104}
384	12	21	{108}
385	12	22	{112}
386	12	23	{117}
387	12	24	{122}
388	12	25	{127}
389	12	26	{133,132,134}
390	12	27	{138}
391	12	28	{143}
392	12	29	{149,154}
393	12	30	{157}
394	12	31	{163}
395	12	32	{172}
396	12	33	{179,174,173}
397	13	1	{1}
398	13	2	{6}
399	13	3	{14}
400	13	4	{17}
401	13	5	{22}
402	13	6	{26}
403	13	7	{31}
404	13	8	{36}
405	13	9	{47}
406	13	10	{51,56,49}
407	13	11	{57}
408	13	12	{62}
409	13	13	{67}
410	13	14	{73}
411	13	15	{77}
412	13	16	{82}
413	13	17	{87}
414	13	18	{92}
415	13	19	{97}
416	13	20	{103}
417	13	21	{109}
418	13	22	{112}
419	13	23	{117}
420	13	24	{122}
421	13	25	{131}
422	13	26	{134,136,137}
423	13	27	{139}
424	13	28	{144}
425	13	29	{152}
426	13	30	{159}
427	13	31	{163,161,165}
428	13	32	{171}
429	13	33	{177}
430	14	1	{1}
431	14	2	{9}
432	14	3	{12}
433	14	4	{16}
434	14	5	{21}
435	14	6	{27}
436	14	7	{31}
437	14	8	{36}
438	14	9	{42,48,43}
439	14	10	{55}
440	14	11	{57}
441	14	12	{63}
442	14	13	{71}
443	14	14	{72}
444	14	15	{77}
445	14	16	{82}
446	14	17	{87}
447	14	18	{92}
448	14	19	{97}
449	14	20	{103}
450	14	21	{108}
451	14	22	{113}
452	14	23	{117}
453	14	24	{126}
454	14	25	{128}
455	14	26	{137}
456	14	27	{138}
457	14	28	{143}
458	14	29	{153,150}
459	14	30	{160}
460	14	31	{167,166,161}
461	14	32	{170}
462	14	33	{181}
463	15	1	{2}
464	15	2	{6}
465	15	3	{11}
466	15	4	{16}
467	15	5	{21}
468	15	6	{26}
469	15	7	{31}
470	15	8	{37}
471	15	9	{42,45}
472	15	10	{53,49,52}
473	15	11	{57}
474	15	12	{62}
475	15	13	{67}
476	15	14	{72}
477	15	15	{77}
478	15	16	{83}
479	15	17	{87}
480	15	18	{93}
481	15	19	{97}
482	15	20	{102}
483	15	21	{108}
484	15	22	{114}
485	15	23	{117}
486	15	24	{122}
487	15	25	{127}
488	15	26	{134,136,137}
489	15	27	{138}
490	15	28	{143}
491	15	29	{151,150,149}
492	15	30	{159}
493	15	31	{166,165}
494	15	32	{170}
495	15	33	{179,181,176}
496	16	1	{1}
497	16	2	{7}
498	16	3	{11}
499	16	4	{16}
500	16	5	{21}
501	16	6	{27}
502	16	7	{31}
503	16	8	{36}
504	16	9	{42,46,45}
505	16	10	{56,52}
506	16	11	{57}
507	16	12	{62}
508	16	13	{67}
509	16	14	{72}
510	16	15	{79}
511	16	16	{82}
512	16	17	{87}
513	16	18	{92}
514	16	19	{97}
515	16	20	{102}
516	16	21	{108}
517	16	22	{112}
518	16	23	{117}
519	16	24	{122}
520	16	25	{127}
521	16	26	{133,135,137}
522	16	27	{138}
523	16	28	{143}
524	16	29	{153,152,154}
525	16	30	{158}
526	16	31	{165,164}
527	16	32	{172}
528	16	33	{173}
529	17	1	{1}
530	17	2	{8}
531	17	3	{11}
532	17	4	{16}
533	17	5	{21}
534	17	6	{26}
535	17	7	{31}
536	17	8	{36}
537	17	9	{47}
538	17	10	{50}
539	17	11	{57}
540	17	12	{63}
541	17	13	{67}
542	17	14	{72}
543	17	15	{79}
544	17	16	{82}
545	17	17	{91}
546	17	18	{92}
547	17	19	{98}
548	17	20	{102}
549	17	21	{108}
550	17	22	{112}
551	17	23	{117}
552	17	24	{122}
553	17	25	{127}
554	17	26	{133,134,136}
555	17	27	{140}
556	17	28	{143}
557	17	29	{151,150}
558	17	30	{160}
559	17	31	{161}
560	17	32	{172}
561	17	33	{178,179}
562	18	1	{2}
563	18	2	{6}
564	18	3	{11}
565	18	4	{17}
566	18	5	{21}
567	18	6	{26}
568	18	7	{31}
569	18	8	{36}
570	18	9	{46,45}
571	18	10	{55,56,52}
572	18	11	{57}
573	18	12	{63}
574	18	13	{67}
575	18	14	{72}
576	18	15	{79}
577	18	16	{82}
578	18	17	{87}
579	18	18	{92}
580	18	19	{99}
581	18	20	{102}
582	18	21	{108}
583	18	22	{115}
584	18	23	{117}
585	18	24	{122}
586	18	25	{127}
587	18	26	{132,134}
588	18	27	{138}
589	18	28	{143}
590	18	29	{153,154}
591	18	30	{158}
592	18	31	{165}
593	18	32	{172}
594	18	33	{178}
595	19	1	{1}
596	19	2	{6}
597	19	3	{11}
598	19	4	{17}
599	19	5	{21}
600	19	6	{26}
601	19	7	{35}
602	19	8	{36}
603	19	9	{42,48,44}
604	19	10	{52}
605	19	11	{57}
606	19	12	{62}
607	19	13	{67}
608	19	14	{74}
609	19	15	{78}
610	19	16	{85}
611	19	17	{88}
612	19	18	{92}
613	19	19	{98}
614	19	20	{102}
615	19	21	{108}
616	19	22	{112}
617	19	23	{117}
618	19	24	{124}
619	19	25	{128}
620	19	26	{132,136}
621	19	27	{142}
622	19	28	{143}
623	19	29	{148}
624	19	30	{160}
625	19	31	{166,165}
626	19	32	{170}
627	19	33	{179,181,175}
628	20	1	{1}
629	20	2	{6}
630	20	3	{12}
631	20	4	{16}
632	20	5	{21}
633	20	6	{30}
634	20	7	{31}
635	20	8	{36}
636	20	9	{44,43,41}
637	20	10	{55}
638	20	11	{58}
639	20	12	{65}
640	20	13	{67}
641	20	14	{72}
642	20	15	{77}
643	20	16	{83}
644	20	17	{87}
645	20	18	{92}
646	20	19	{97}
647	20	20	{105}
648	20	21	{111}
649	20	22	{112}
650	20	23	{120}
651	20	24	{122}
652	20	25	{127}
653	20	26	{133}
654	20	27	{138}
655	20	28	{143}
656	20	29	{148,153}
657	20	30	{160}
658	20	31	{163,162,164}
659	20	32	{170}
660	20	33	{178}
661	21	1	{3}
662	21	2	{9}
663	21	3	{11}
664	21	4	{17}
665	21	5	{21}
666	21	6	{26}
667	21	7	{31}
668	21	8	{36}
669	21	9	{42}
670	21	10	{56,49}
671	21	11	{57}
672	21	12	{62}
673	21	13	{67}
674	21	14	{73}
675	21	15	{77}
676	21	16	{82}
677	21	17	{87}
678	21	18	{92}
679	21	19	{98}
680	21	20	{103}
681	21	21	{108}
682	21	22	{112}
683	21	23	{117}
684	21	24	{122}
685	21	25	{127}
686	21	26	{133,132,136}
687	21	27	{139}
688	21	28	{143}
689	21	29	{154}
690	21	30	{157}
691	21	31	{163,165}
692	21	32	{172}
693	21	33	{173}
694	22	1	{2}
695	22	2	{6}
696	22	3	{12}
697	22	4	{19}
698	22	5	{21}
699	22	6	{27}
700	22	7	{31}
701	22	8	{36}
702	22	9	{47}
703	22	10	{55}
704	22	11	{61}
705	22	12	{62}
706	22	13	{67}
707	22	14	{72}
708	22	15	{77}
709	22	16	{82}
710	22	17	{87}
711	22	18	{92}
712	22	19	{101}
713	22	20	{102}
714	22	21	{108}
715	22	22	{112}
716	22	23	{118}
717	22	24	{123}
718	22	25	{127}
719	22	26	{133,137}
720	22	27	{138}
721	22	28	{144}
722	22	29	{150,149,154}
723	22	30	{156}
724	22	31	{165}
725	22	32	{170}
726	22	33	{175}
727	23	1	{1}
728	23	2	{7}
729	23	3	{12}
730	23	4	{16}
731	23	5	{21}
732	23	6	{26}
733	23	7	{31}
734	23	8	{36}
735	23	9	{46}
736	23	10	{51}
737	23	11	{57}
738	23	12	{62}
739	23	13	{67}
740	23	14	{72}
741	23	15	{77}
742	23	16	{82}
743	23	17	{87}
744	23	18	{93}
745	23	19	{97}
746	23	20	{102}
747	23	21	{108}
748	23	22	{112}
749	23	23	{117}
750	23	24	{123}
751	23	25	{128}
752	23	26	{132}
753	23	27	{138}
754	23	28	{143}
755	23	29	{153,152,149}
756	23	30	{158}
757	23	31	{168,169,164}
758	23	32	{172}
759	23	33	{180}
760	24	1	{1}
761	24	2	{6}
762	24	3	{11}
763	24	4	{17}
764	24	5	{21}
765	24	6	{27}
766	24	7	{32}
767	24	8	{36}
768	24	9	{41,47,45}
769	24	10	{54,53,52}
770	24	11	{57}
771	24	12	{62}
772	24	13	{67}
773	24	14	{72}
774	24	15	{77}
775	24	16	{83}
776	24	17	{87}
777	24	18	{92}
778	24	19	{97}
779	24	20	{102}
780	24	21	{108}
781	24	22	{112}
782	24	23	{119}
783	24	24	{122}
784	24	25	{129}
785	24	26	{133,132,135}
786	24	27	{139}
787	24	28	{145}
788	24	29	{152,150,155}
789	24	30	{157}
790	24	31	{168,161,169}
791	24	32	{171}
792	24	33	{179,175,174}
793	25	1	{2}
794	25	2	{6}
795	25	3	{12}
796	25	4	{17}
797	25	5	{21}
798	25	6	{26}
799	25	7	{31}
800	25	8	{36}
801	25	9	{46,44,43}
802	25	10	{56,52}
803	25	11	{57}
804	25	12	{62}
805	25	13	{67}
806	25	14	{72}
807	25	15	{77}
808	25	16	{82}
809	25	17	{87}
810	25	18	{93}
811	25	19	{97}
812	25	20	{106}
813	25	21	{108}
814	25	22	{113}
815	25	23	{117}
816	25	24	{123}
817	25	25	{127}
818	25	26	{132,135}
819	25	27	{138}
820	25	28	{143}
821	25	29	{152,150,155}
822	25	30	{158}
823	25	31	{163,166}
824	25	32	{170}
825	25	33	{179,180}
826	26	1	{1}
827	26	2	{6}
828	26	3	{11}
829	26	4	{16}
830	26	5	{22}
831	26	6	{27}
832	26	7	{31}
833	26	8	{36}
834	26	9	{42,48}
835	26	10	{55,52}
836	26	11	{58}
837	26	12	{63}
838	26	13	{67}
839	26	14	{72}
840	26	15	{78}
841	26	16	{82}
842	26	17	{87}
843	26	18	{93}
844	26	19	{97}
845	26	20	{103}
846	26	21	{108}
847	26	22	{112}
848	26	23	{117}
849	26	24	{122}
850	26	25	{127}
851	26	26	{134}
852	26	27	{141}
853	26	28	{143}
854	26	29	{151,154,155}
855	26	30	{159}
856	26	31	{161}
857	26	32	{170}
858	26	33	{180,175}
859	27	1	{2}
860	27	2	{6}
861	27	3	{11}
862	27	4	{16}
863	27	5	{21}
864	27	6	{26}
865	27	7	{35}
866	27	8	{36}
867	27	9	{42,46,43}
868	27	10	{51,56}
869	27	11	{58}
870	27	12	{62}
871	27	13	{67}
872	27	14	{72}
873	27	15	{77}
874	27	16	{82}
875	27	17	{88}
876	27	18	{92}
877	27	19	{99}
878	27	20	{104}
879	27	21	{108}
880	27	22	{114}
881	27	23	{117}
882	27	24	{122}
883	27	25	{131}
884	27	26	{135}
885	27	27	{138}
886	27	28	{143}
887	27	29	{150,154}
888	27	30	{160}
889	27	31	{167}
890	27	32	{170}
891	27	33	{178,176,174}
892	28	1	{1}
893	28	2	{9}
894	28	3	{11}
895	28	4	{16}
896	28	5	{23}
897	28	6	{26}
898	28	7	{31}
899	28	8	{36}
900	28	9	{44}
901	28	10	{53,50,51}
902	28	11	{57}
903	28	12	{63}
904	28	13	{67}
905	28	14	{72}
906	28	15	{78}
907	28	16	{82}
908	28	17	{88}
909	28	18	{92}
910	28	19	{98}
911	28	20	{102}
912	28	21	{109}
913	28	22	{112}
914	28	23	{118}
915	28	24	{122}
916	28	25	{127}
917	28	26	{133,135}
918	28	27	{138}
919	28	28	{144}
920	28	29	{148,152}
921	28	30	{157}
922	28	31	{166}
923	28	32	{172}
924	28	33	{178,179,176}
925	29	1	{1}
926	29	2	{6}
927	29	3	{11}
928	29	4	{16}
929	29	5	{21}
930	29	6	{26}
931	29	7	{31}
932	29	8	{36}
933	29	9	{48,46}
934	29	10	{49}
935	29	11	{60}
936	29	12	{62}
937	29	13	{67}
938	29	14	{72}
939	29	15	{77}
940	29	16	{83}
941	29	17	{90}
942	29	18	{92}
943	29	19	{97}
944	29	20	{102}
945	29	21	{108}
946	29	22	{112}
947	29	23	{117}
948	29	24	{122}
949	29	25	{128}
950	29	26	{134}
951	29	27	{141}
952	29	28	{143}
953	29	29	{148,153,155}
954	29	30	{157}
955	29	31	{168,165,169}
956	29	32	{170}
957	29	33	{181,176,174}
958	30	1	{1}
959	30	2	{6}
960	30	3	{11}
961	30	4	{16}
962	30	5	{21}
963	30	6	{26}
964	30	7	{31}
965	30	8	{36}
966	30	9	{42,48,45}
967	30	10	{50}
968	30	11	{58}
969	30	12	{62}
970	30	13	{68}
971	30	14	{72}
972	30	15	{77}
973	30	16	{83}
974	30	17	{87}
975	30	18	{92}
976	30	19	{99}
977	30	20	{102}
978	30	21	{109}
979	30	22	{112}
980	30	23	{117}
981	30	24	{122}
982	30	25	{127}
983	30	26	{132,135,137}
984	30	27	{138}
985	30	28	{143}
986	30	29	{154}
987	30	30	{157}
988	30	31	{165}
989	30	32	{172}
990	30	33	{181}
991	31	1	{1}
992	31	2	{6}
993	31	3	{11}
994	31	4	{16}
995	31	5	{24}
996	31	6	{26}
997	31	7	{32}
998	31	8	{39}
999	31	9	{48,47}
1000	31	10	{53,49,52}
1001	31	11	{57}
1002	31	12	{63}
1003	31	13	{67}
1004	31	14	{72}
1005	31	15	{77}
1006	31	16	{82}
1007	31	17	{87}
1008	31	18	{92}
1009	31	19	{97}
1010	31	20	{102}
1011	31	21	{109}
1012	31	22	{112}
1013	31	23	{117}
1014	31	24	{125}
1015	31	25	{128}
1016	31	26	{133}
1017	31	27	{139}
1018	31	28	{143}
1019	31	29	{150,154,155}
1020	31	30	{160}
1021	31	31	{165}
1022	31	32	{172}
1023	31	33	{178,176}
1024	32	1	{1}
1025	32	2	{7}
1026	32	3	{11}
1027	32	4	{16}
1028	32	5	{21}
1029	32	6	{26}
1030	32	7	{33}
1031	32	8	{37}
1032	32	9	{43,47,45}
1033	32	10	{53}
1034	32	11	{57}
1035	32	12	{62}
1036	32	13	{68}
1037	32	14	{73}
1038	32	15	{77}
1039	32	16	{85}
1040	32	17	{91}
1041	32	18	{92}
1042	32	19	{98}
1043	32	20	{102}
1044	32	21	{108}
1045	32	22	{112}
1046	32	23	{121}
1047	32	24	{122}
1048	32	25	{127}
1049	32	26	{133,132,137}
1050	32	27	{138}
1051	32	28	{143}
1052	32	29	{152,150,149}
1053	32	30	{156}
1054	32	31	{161,169}
1055	32	32	{171}
1056	32	33	{178,176,177}
1057	33	1	{1}
1058	33	2	{7}
1059	33	3	{11}
1060	33	4	{16}
1061	33	5	{21}
1062	33	6	{26}
1063	33	7	{31}
1064	33	8	{36}
1065	33	9	{42}
1066	33	10	{53,51,55}
1067	33	11	{57}
1068	33	12	{62}
1069	33	13	{67}
1070	33	14	{76}
1071	33	15	{80}
1072	33	16	{82}
1073	33	17	{87}
1074	33	18	{92}
1075	33	19	{97}
1076	33	20	{102}
1077	33	21	{109}
1078	33	22	{112}
1079	33	23	{117}
1080	33	24	{122}
1081	33	25	{127}
1082	33	26	{132}
1083	33	27	{138}
1084	33	28	{143}
1085	33	29	{150,149}
1086	33	30	{156}
1087	33	31	{161,162}
1088	33	32	{172}
1089	33	33	{179,177}
1090	34	1	{1}
1091	34	2	{6}
1092	34	3	{13}
1093	34	4	{17}
1094	34	5	{21}
1095	34	6	{27}
1096	34	7	{31}
1097	34	8	{36}
1098	34	9	{42,46,41}
1099	34	10	{53}
1100	34	11	{57}
1101	34	12	{62}
1102	34	13	{67}
1103	34	14	{72}
1104	34	15	{77}
1105	34	16	{82}
1106	34	17	{87}
1107	34	18	{92}
1108	34	19	{97}
1109	34	20	{102}
1110	34	21	{108}
1111	34	22	{112}
1112	34	23	{117}
1113	34	24	{122}
1114	34	25	{127}
1115	34	26	{133,136,137}
1116	34	27	{138}
1117	34	28	{143}
1118	34	29	{153}
1119	34	30	{158}
1120	34	31	{168,165,169}
1121	34	32	{170}
1122	34	33	{180,174}
1123	35	1	{1}
1124	35	2	{6}
1125	35	3	{11}
1126	35	4	{16}
1127	35	5	{21}
1128	35	6	{26}
1129	35	7	{31}
1130	35	8	{36}
1131	35	9	{41,47}
1132	35	10	{54,50}
1133	35	11	{57}
1134	35	12	{62}
1135	35	13	{67}
1136	35	14	{72}
1137	35	15	{77}
1138	35	16	{82}
1139	35	17	{87}
1140	35	18	{93}
1141	35	19	{97}
1142	35	20	{103}
1143	35	21	{108}
1144	35	22	{112}
1145	35	23	{117}
1146	35	24	{122}
1147	35	25	{128}
1148	35	26	{136}
1149	35	27	{139}
1150	35	28	{143}
1151	35	29	{148,153,149}
1152	35	30	{159}
1153	35	31	{163,166,169}
1154	35	32	{171}
1155	35	33	{181}
1156	36	1	{1}
1157	36	2	{6}
1158	36	3	{12}
1159	36	4	{16}
1160	36	5	{21}
1161	36	6	{26}
1162	36	7	{35}
1163	36	8	{36}
1164	36	9	{46,44,47}
1165	36	10	{54,51,52}
1166	36	11	{57}
1167	36	12	{62}
1168	36	13	{67}
1169	36	14	{75}
1170	36	15	{77}
1171	36	16	{83}
1172	36	17	{87}
1173	36	18	{92}
1174	36	19	{97}
1175	36	20	{103}
1176	36	21	{109}
1177	36	22	{113}
1178	36	23	{117}
1179	36	24	{122}
1180	36	25	{127}
1181	36	26	{132}
1182	36	27	{138}
1183	36	28	{144}
1184	36	29	{151,148}
1185	36	30	{160}
1186	36	31	{162}
1187	36	32	{171}
1188	36	33	{175,174}
1189	37	1	{1}
1190	37	2	{6}
1191	37	3	{11}
1192	37	4	{16}
1193	37	5	{21}
1194	37	6	{27}
1195	37	7	{33}
1196	37	8	{36}
1197	37	9	{48,47,45}
1198	37	10	{50,55}
1199	37	11	{58}
1200	37	12	{62}
1201	37	13	{67}
1202	37	14	{72}
1203	37	15	{79}
1204	37	16	{82}
1205	37	17	{88}
1206	37	18	{92}
1207	37	19	{97}
1208	37	20	{102}
1209	37	21	{111}
1210	37	22	{113}
1211	37	23	{117}
1212	37	24	{122}
1213	37	25	{127}
1214	37	26	{132,134}
1215	37	27	{138}
1216	37	28	{143}
1217	37	29	{148}
1218	37	30	{160}
1219	37	31	{164}
1220	37	32	{170}
1221	37	33	{179,175}
1222	38	1	{1}
1223	38	2	{6}
1224	38	3	{11}
1225	38	4	{16}
1226	38	5	{22}
1227	38	6	{26}
1228	38	7	{31}
1229	38	8	{36}
1230	38	9	{41}
1231	38	10	{54}
1232	38	11	{58}
1233	38	12	{62}
1234	38	13	{70}
1235	38	14	{73}
1236	38	15	{77}
1237	38	16	{82}
1238	38	17	{87}
1239	38	18	{92}
1240	38	19	{97}
1241	38	20	{104}
1242	38	21	{108}
1243	38	22	{112}
1244	38	23	{117}
1245	38	24	{123}
1246	38	25	{128}
1247	38	26	{133,135}
1248	38	27	{138}
1249	38	28	{143}
1250	38	29	{152,154}
1251	38	30	{157}
1252	38	31	{168}
1253	38	32	{170}
1254	38	33	{175,173}
1255	39	1	{2}
1256	39	2	{6}
1257	39	3	{11}
1258	39	4	{16}
1259	39	5	{21}
1260	39	6	{27}
1261	39	7	{31}
1262	39	8	{40}
1263	39	9	{44,43,47}
1264	39	10	{50,51}
1265	39	11	{58}
1266	39	12	{62}
1267	39	13	{70}
1268	39	14	{72}
1269	39	15	{81}
1270	39	16	{82}
1271	39	17	{87}
1272	39	18	{92}
1273	39	19	{97}
1274	39	20	{102}
1275	39	21	{108}
1276	39	22	{112}
1277	39	23	{117}
1278	39	24	{122}
1279	39	25	{127}
1280	39	26	{133,134}
1281	39	27	{138}
1282	39	28	{143}
1283	39	29	{149,154}
1284	39	30	{159}
1285	39	31	{161,162}
1286	39	32	{171}
1287	39	33	{179,181,173}
1288	40	1	{1}
1289	40	2	{6}
1290	40	3	{11}
1291	40	4	{16}
1292	40	5	{25}
1293	40	6	{26}
1294	40	7	{31}
1295	40	8	{36}
1296	40	9	{47}
1297	40	10	{53,50,56}
1298	40	11	{58}
1299	40	12	{62}
1300	40	13	{67}
1301	40	14	{73}
1302	40	15	{80}
1303	40	16	{82}
1304	40	17	{87}
1305	40	18	{92}
1306	40	19	{97}
1307	40	20	{103}
1308	40	21	{108}
1309	40	22	{112}
1310	40	23	{117}
1311	40	24	{122}
1312	40	25	{128}
1313	40	26	{133,137}
1314	40	27	{138}
1315	40	28	{143}
1316	40	29	{153}
1317	40	30	{157}
1318	40	31	{163,164}
1319	40	32	{170}
1320	40	33	{180}
1321	41	1	{1}
1322	41	2	{6}
1323	41	3	{12}
1324	41	4	{18}
1325	41	5	{23}
1326	41	6	{26}
1327	41	7	{31}
1328	41	8	{37}
1329	41	9	{48}
1330	41	10	{50,49,52}
1331	41	11	{57}
1332	41	12	{62}
1333	41	13	{67}
1334	41	14	{72}
1335	41	15	{77}
1336	41	16	{82}
1337	41	17	{87}
1338	41	18	{92}
1339	41	19	{98}
1340	41	20	{102}
1341	41	21	{108}
1342	41	22	{112}
1343	41	23	{121}
1344	41	24	{123}
1345	41	25	{127}
1346	41	26	{133,132,136}
1347	41	27	{138}
1348	41	28	{143}
1349	41	29	{152,150,155}
1350	41	30	{160}
1351	41	31	{163,165,164}
1352	41	32	{171}
1353	41	33	{178}
1354	42	1	{1}
1355	42	2	{7}
1356	42	3	{14}
1357	42	4	{16}
1358	42	5	{22}
1359	42	6	{26}
1360	42	7	{32}
1361	42	8	{36}
1362	42	9	{42,48,44}
1363	42	10	{54,49,52}
1364	42	11	{58}
1365	42	12	{62}
1366	42	13	{68}
1367	42	14	{76}
1368	42	15	{77}
1369	42	16	{82}
1370	42	17	{87}
1371	42	18	{92}
1372	42	19	{97}
1373	42	20	{102}
1374	42	21	{108}
1375	42	22	{112}
1376	42	23	{117}
1377	42	24	{122}
1378	42	25	{127}
1379	42	26	{133,132,137}
1380	42	27	{138}
1381	42	28	{143}
1382	42	29	{149}
1383	42	30	{158}
1384	42	31	{161,162,165}
1385	42	32	{171}
1386	42	33	{176,177,173}
1387	43	1	{1}
1388	43	2	{6}
1389	43	3	{11}
1390	43	4	{17}
1391	43	5	{21}
1392	43	6	{26}
1393	43	7	{31}
1394	43	8	{40}
1395	43	9	{46,44,47}
1396	43	10	{54,51}
1397	43	11	{57}
1398	43	12	{62}
1399	43	13	{67}
1400	43	14	{72}
1401	43	15	{77}
1402	43	16	{82}
1403	43	17	{87}
1404	43	18	{93}
1405	43	19	{97}
1406	43	20	{102}
1407	43	21	{108}
1408	43	22	{112}
1409	43	23	{118}
1410	43	24	{122}
1411	43	25	{127}
1412	43	26	{133,132}
1413	43	27	{141}
1414	43	28	{143}
1415	43	29	{151,150,149}
1416	43	30	{158}
1417	43	31	{168,162,164}
1418	43	32	{171}
1419	43	33	{174,177}
1420	44	1	{4}
1421	44	2	{8}
1422	44	3	{11}
1423	44	4	{16}
1424	44	5	{21}
1425	44	6	{26}
1426	44	7	{31}
1427	44	8	{37}
1428	44	9	{48,44}
1429	44	10	{50,51}
1430	44	11	{57}
1431	44	12	{62}
1432	44	13	{67}
1433	44	14	{73}
1434	44	15	{77}
1435	44	16	{82}
1436	44	17	{87}
1437	44	18	{92}
1438	44	19	{98}
1439	44	20	{103}
1440	44	21	{109}
1441	44	22	{112}
1442	44	23	{118}
1443	44	24	{122}
1444	44	25	{131}
1445	44	26	{133,134,136}
1446	44	27	{138}
1447	44	28	{145}
1448	44	29	{152}
1449	44	30	{157}
1450	44	31	{167,165}
1451	44	32	{172}
1452	44	33	{175,174}
1453	45	1	{1}
1454	45	2	{6}
1455	45	3	{12}
1456	45	4	{16}
1457	45	5	{23}
1458	45	6	{26}
1459	45	7	{31}
1460	45	8	{36}
1461	45	9	{46,47,45}
1462	45	10	{56,52}
1463	45	11	{58}
1464	45	12	{62}
1465	45	13	{68}
1466	45	14	{72}
1467	45	15	{77}
1468	45	16	{83}
1469	45	17	{90}
1470	45	18	{95}
1471	45	19	{98}
1472	45	20	{102}
1473	45	21	{109}
1474	45	22	{113}
1475	45	23	{117}
1476	45	24	{122}
1477	45	25	{129}
1478	45	26	{135}
1479	45	27	{138}
1480	45	28	{143}
1481	45	29	{148}
1482	45	30	{157}
1483	45	31	{163,166,169}
1484	45	32	{171}
1485	45	33	{181,173}
1486	46	1	{3}
1487	46	2	{10}
1488	46	3	{11}
1489	46	4	{16}
1490	46	5	{21}
1491	46	6	{28}
1492	46	7	{32}
1493	46	8	{36}
1494	46	9	{46,47}
1495	46	10	{54,49,52}
1496	46	11	{57}
1497	46	12	{63}
1498	46	13	{68}
1499	46	14	{72}
1500	46	15	{77}
1501	46	16	{82}
1502	46	17	{87}
1503	46	18	{94}
1504	46	19	{97}
1505	46	20	{102}
1506	46	21	{108}
1507	46	22	{112}
1508	46	23	{117}
1509	46	24	{122}
1510	46	25	{127}
1511	46	26	{135,134,136}
1512	46	27	{140}
1513	46	28	{143}
1514	46	29	{153,150,149}
1515	46	30	{160}
1516	46	31	{163,168,169}
1517	46	32	{170}
1518	46	33	{174,177}
1519	47	1	{1}
1520	47	2	{6}
1521	47	3	{12}
1522	47	4	{16}
1523	47	5	{21}
1524	47	6	{26}
1525	47	7	{32}
1526	47	8	{36}
1527	47	9	{43}
1528	47	10	{50,51,52}
1529	47	11	{57}
1530	47	12	{62}
1531	47	13	{67}
1532	47	14	{72}
1533	47	15	{80}
1534	47	16	{82}
1535	47	17	{87}
1536	47	18	{92}
1537	47	19	{97}
1538	47	20	{102}
1539	47	21	{108}
1540	47	22	{113}
1541	47	23	{117}
1542	47	24	{122}
1543	47	25	{127}
1544	47	26	{133,132,137}
1545	47	27	{138}
1546	47	28	{143}
1547	47	29	{148,153,154}
1548	47	30	{157}
1549	47	31	{168,161,165}
1550	47	32	{172}
1551	47	33	{181,173}
1552	48	1	{1}
1553	48	2	{6}
1554	48	3	{11}
1555	48	4	{16}
1556	48	5	{21}
1557	48	6	{26}
1558	48	7	{34}
1559	48	8	{37}
1560	48	9	{48,46,47}
1561	48	10	{55}
1562	48	11	{58}
1563	48	12	{62}
1564	48	13	{67}
1565	48	14	{72}
1566	48	15	{77}
1567	48	16	{85}
1568	48	17	{87}
1569	48	18	{92}
1570	48	19	{97}
1571	48	20	{102}
1572	48	21	{111}
1573	48	22	{112}
1574	48	23	{118}
1575	48	24	{122}
1576	48	25	{127}
1577	48	26	{136,137}
1578	48	27	{138}
1579	48	28	{143}
1580	48	29	{152,155}
1581	48	30	{160}
1582	48	31	{168,165}
1583	48	32	{172}
1584	48	33	{178,181,176}
1585	49	1	{1}
1586	49	2	{6}
1587	49	3	{11}
1588	49	4	{16}
1589	49	5	{21}
1590	49	6	{27}
1591	49	7	{31}
1592	49	8	{37}
1593	49	9	{42}
1594	49	10	{54,53,51}
1595	49	11	{57}
1596	49	12	{62}
1597	49	13	{68}
1598	49	14	{72}
1599	49	15	{77}
1600	49	16	{83}
1601	49	17	{87}
1602	49	18	{92}
1603	49	19	{99}
1604	49	20	{102}
1605	49	21	{109}
1606	49	22	{113}
1607	49	23	{117}
1608	49	24	{122}
1609	49	25	{127}
1610	49	26	{135}
1611	49	27	{138}
1612	49	28	{144}
1613	49	29	{153,149}
1614	49	30	{156}
1615	49	31	{166,165,169}
1616	49	32	{171}
1617	49	33	{176}
1618	50	1	{2}
1619	50	2	{6}
1620	50	3	{12}
1621	50	4	{17}
1622	50	5	{21}
1623	50	6	{26}
1624	50	7	{31}
1625	50	8	{36}
1626	50	9	{46}
1627	50	10	{54,50,51}
1628	50	11	{61}
1629	50	12	{64}
1630	50	13	{69}
1631	50	14	{73}
1632	50	15	{77}
1633	50	16	{82}
1634	50	17	{87}
1635	50	18	{93}
1636	50	19	{98}
1637	50	20	{102}
1638	50	21	{108}
1639	50	22	{112}
1640	50	23	{117}
1641	50	24	{123}
1642	50	25	{128}
1643	50	26	{133,132,136}
1644	50	27	{138}
1645	50	28	{143}
1646	50	29	{153,149,154}
1647	50	30	{160}
1648	50	31	{166}
1649	50	32	{172}
1650	50	33	{179,181,175}
1651	51	1	{1}
1652	51	2	{6}
1653	51	3	{12}
1654	51	4	{16}
1655	51	5	{21}
1656	51	6	{28}
1657	51	7	{32}
1658	51	8	{37}
1659	51	9	{41}
1660	51	10	{54,55}
1661	51	11	{58}
1662	51	12	{62}
1663	51	13	{67}
1664	51	14	{75}
1665	51	15	{77}
1666	51	16	{82}
1667	51	17	{87}
1668	51	18	{92}
1669	51	19	{97}
1670	51	20	{102}
1671	51	21	{108}
1672	51	22	{113}
1673	51	23	{117}
1674	51	24	{122}
1675	51	25	{127}
1676	51	26	{132}
1677	51	27	{138}
1678	51	28	{145}
1679	51	29	{150,149}
1680	51	30	{158}
1681	51	31	{163,167,169}
1682	51	32	{172}
1683	51	33	{176}
1684	52	1	{1}
1685	52	2	{6}
1686	52	3	{14}
1687	52	4	{16}
1688	52	5	{21}
1689	52	6	{26}
1690	52	7	{34}
1691	52	8	{37}
1692	52	9	{42}
1693	52	10	{51,55,52}
1694	52	11	{59}
1695	52	12	{62}
1696	52	13	{67}
1697	52	14	{72}
1698	52	15	{77}
1699	52	16	{83}
1700	52	17	{88}
1701	52	18	{93}
1702	52	19	{97}
1703	52	20	{102}
1704	52	21	{108}
1705	52	22	{113}
1706	52	23	{117}
1707	52	24	{123}
1708	52	25	{127}
1709	52	26	{136}
1710	52	27	{138}
1711	52	28	{143}
1712	52	29	{151,154}
1713	52	30	{157}
1714	52	31	{168,165}
1715	52	32	{170}
1716	52	33	{181,173}
1717	53	1	{2}
1718	53	2	{6}
1719	53	3	{14}
1720	53	4	{16}
1721	53	5	{21}
1722	53	6	{26}
1723	53	7	{32}
1724	53	8	{36}
1725	53	9	{48}
1726	53	10	{55}
1727	53	11	{57}
1728	53	12	{62}
1729	53	13	{67}
1730	53	14	{72}
1731	53	15	{79}
1732	53	16	{82}
1733	53	17	{87}
1734	53	18	{92}
1735	53	19	{97}
1736	53	20	{103}
1737	53	21	{108}
1738	53	22	{113}
1739	53	23	{117}
1740	53	24	{122}
1741	53	25	{128}
1742	53	26	{133,135,134}
1743	53	27	{139}
1744	53	28	{143}
1745	53	29	{153}
1746	53	30	{158}
1747	53	31	{168,161,169}
1748	53	32	{170}
1749	53	33	{179,174}
1750	54	1	{1}
1751	54	2	{6}
1752	54	3	{11}
1753	54	4	{16}
1754	54	5	{25}
1755	54	6	{27}
1756	54	7	{32}
1757	54	8	{36}
1758	54	9	{41}
1759	54	10	{51,55}
1760	54	11	{57}
1761	54	12	{62}
1762	54	13	{67}
1763	54	14	{73}
1764	54	15	{81}
1765	54	16	{82}
1766	54	17	{88}
1767	54	18	{93}
1768	54	19	{97}
1769	54	20	{102}
1770	54	21	{108}
1771	54	22	{112}
1772	54	23	{117}
1773	54	24	{125}
1774	54	25	{127}
1775	54	26	{135,137}
1776	54	27	{138}
1777	54	28	{144}
1778	54	29	{151,155}
1779	54	30	{156}
1780	54	31	{165}
1781	54	32	{172}
1782	54	33	{174,177}
1783	55	1	{1}
1784	55	2	{7}
1785	55	3	{11}
1786	55	4	{17}
1787	55	5	{21}
1788	55	6	{26}
1789	55	7	{31}
1790	55	8	{39}
1791	55	9	{47}
1792	55	10	{54,55,49}
1793	55	11	{57}
1794	55	12	{62}
1795	55	13	{67}
1796	55	14	{72}
1797	55	15	{81}
1798	55	16	{82}
1799	55	17	{87}
1800	55	18	{92}
1801	55	19	{99}
1802	55	20	{102}
1803	55	21	{108}
1804	55	22	{113}
1805	55	23	{118}
1806	55	24	{123}
1807	55	25	{127}
1808	55	26	{132,136}
1809	55	27	{138}
1810	55	28	{144}
1811	55	29	{148,152}
1812	55	30	{156}
1813	55	31	{161,162,165}
1814	55	32	{171}
1815	55	33	{176,175}
1816	56	1	{4}
1817	56	2	{6}
1818	56	3	{11}
1819	56	4	{17}
1820	56	5	{21}
1821	56	6	{26}
1822	56	7	{31}
1823	56	8	{36}
1824	56	9	{42,44}
1825	56	10	{53,50}
1826	56	11	{57}
1827	56	12	{64}
1828	56	13	{67}
1829	56	14	{72}
1830	56	15	{78}
1831	56	16	{82}
1832	56	17	{88}
1833	56	18	{92}
1834	56	19	{97}
1835	56	20	{103}
1836	56	21	{108}
1837	56	22	{112}
1838	56	23	{117}
1839	56	24	{122}
1840	56	25	{127}
1841	56	26	{133,135}
1842	56	27	{139}
1843	56	28	{143}
1844	56	29	{148,153}
1845	56	30	{159}
1846	56	31	{163,166,169}
1847	56	32	{171}
1848	56	33	{178,177}
1849	57	1	{1}
1850	57	2	{6}
1851	57	3	{11}
1852	57	4	{17}
1853	57	5	{21}
1854	57	6	{26}
1855	57	7	{31}
1856	57	8	{36}
1857	57	9	{44}
1858	57	10	{53,52}
1859	57	11	{59}
1860	57	12	{64}
1861	57	13	{67}
1862	57	14	{72}
1863	57	15	{77}
1864	57	16	{82}
1865	57	17	{87}
1866	57	18	{92}
1867	57	19	{97}
1868	57	20	{103}
1869	57	21	{108}
1870	57	22	{112}
1871	57	23	{117}
1872	57	24	{122}
1873	57	25	{127}
1874	57	26	{133,132,137}
1875	57	27	{139}
1876	57	28	{143}
1877	57	29	{153,152,149}
1878	57	30	{157}
1879	57	31	{167,166,165}
1880	57	32	{170}
1881	57	33	{173}
1882	58	1	{2}
1883	58	2	{6}
1884	58	3	{11}
1885	58	4	{17}
1886	58	5	{21}
1887	58	6	{26}
1888	58	7	{31}
1889	58	8	{36}
1890	58	9	{48,47}
1891	58	10	{56,49,52}
1892	58	11	{57}
1893	58	12	{62}
1894	58	13	{67}
1895	58	14	{72}
1896	58	15	{77}
1897	58	16	{82}
1898	58	17	{87}
1899	58	18	{92}
1900	58	19	{97}
1901	58	20	{103}
1902	58	21	{108}
1903	58	22	{113}
1904	58	23	{117}
1905	58	24	{124}
1906	58	25	{131}
1907	58	26	{133,136}
1908	58	27	{139}
1909	58	28	{143}
1910	58	29	{150,155}
1911	58	30	{157}
1912	58	31	{166,161,165}
1913	58	32	{171}
1914	58	33	{180}
1915	59	1	{1}
1916	59	2	{6}
1917	59	3	{14}
1918	59	4	{19}
1919	59	5	{21}
1920	59	6	{26}
1921	59	7	{31}
1922	59	8	{36}
1923	59	9	{46}
1924	59	10	{55,49,52}
1925	59	11	{57}
1926	59	12	{63}
1927	59	13	{67}
1928	59	14	{76}
1929	59	15	{77}
1930	59	16	{82}
1931	59	17	{87}
1932	59	18	{92}
1933	59	19	{97}
1934	59	20	{102}
1935	59	21	{108}
1936	59	22	{112}
1937	59	23	{117}
1938	59	24	{122}
1939	59	25	{129}
1940	59	26	{133}
1941	59	27	{138}
1942	59	28	{143}
1943	59	29	{154,155}
1944	59	30	{159}
1945	59	31	{163,161,162}
1946	59	32	{171}
1947	59	33	{174}
1948	60	1	{1}
1949	60	2	{6}
1950	60	3	{12}
1951	60	4	{16}
1952	60	5	{21}
1953	60	6	{26}
1954	60	7	{32}
1955	60	8	{36}
1956	60	9	{42}
1957	60	10	{50,55}
1958	60	11	{58}
1959	60	12	{62}
1960	60	13	{67}
1961	60	14	{72}
1962	60	15	{81}
1963	60	16	{82}
1964	60	17	{87}
1965	60	18	{93}
1966	60	19	{98}
1967	60	20	{102}
1968	60	21	{108}
1969	60	22	{112}
1970	60	23	{118}
1971	60	24	{123}
1972	60	25	{127}
1973	60	26	{134,136,137}
1974	60	27	{139}
1975	60	28	{143}
1976	60	29	{152,149}
1977	60	30	{159}
1978	60	31	{164}
1979	60	32	{170}
1980	60	33	{181,180}
1981	61	1	{1}
1982	61	2	{7}
1983	61	3	{11}
1984	61	4	{17}
1985	61	5	{21}
1986	61	6	{26}
1987	61	7	{31}
1988	61	8	{36}
1989	61	9	{42,41,47}
1990	61	10	{54,53,50}
1991	61	11	{58}
1992	61	12	{62}
1993	61	13	{67}
1994	61	14	{72}
1995	61	15	{77}
1996	61	16	{82}
1997	61	17	{87}
1998	61	18	{92}
1999	61	19	{98}
2000	61	20	{102}
2001	61	21	{109}
2002	61	22	{112}
2003	61	23	{117}
2004	61	24	{122}
2005	61	25	{127}
2006	61	26	{132,137}
2007	61	27	{138}
2008	61	28	{143}
2009	61	29	{154}
2010	61	30	{158}
2011	61	31	{166,169}
2012	61	32	{170}
2013	61	33	{178,174,173}
2014	62	1	{1}
2015	62	2	{6}
2016	62	3	{12}
2017	62	4	{16}
2018	62	5	{25}
2019	62	6	{26}
2020	62	7	{31}
2021	62	8	{37}
2022	62	9	{43}
2023	62	10	{53}
2024	62	11	{57}
2025	62	12	{62}
2026	62	13	{68}
2027	62	14	{74}
2028	62	15	{77}
2029	62	16	{82}
2030	62	17	{88}
2031	62	18	{92}
2032	62	19	{98}
2033	62	20	{103}
2034	62	21	{108}
2035	62	22	{112}
2036	62	23	{119}
2037	62	24	{125}
2038	62	25	{127}
2039	62	26	{132,135}
2040	62	27	{138}
2041	62	28	{144}
2042	62	29	{153}
2043	62	30	{160}
2044	62	31	{162,165,164}
2045	62	32	{171}
2046	62	33	{181,176,174}
2047	63	1	{1}
2048	63	2	{6}
2049	63	3	{13}
2050	63	4	{16}
2051	63	5	{21}
2052	63	6	{28}
2053	63	7	{32}
2054	63	8	{36}
2055	63	9	{41}
2056	63	10	{55,49}
2057	63	11	{57}
2058	63	12	{64}
2059	63	13	{67}
2060	63	14	{72}
2061	63	15	{77}
2062	63	16	{82}
2063	63	17	{88}
2064	63	18	{92}
2065	63	19	{98}
2066	63	20	{102}
2067	63	21	{108}
2068	63	22	{112}
2069	63	23	{121}
2070	63	24	{123}
2071	63	25	{127}
2072	63	26	{133,134}
2073	63	27	{138}
2074	63	28	{143}
2075	63	29	{148}
2076	63	30	{159}
2077	63	31	{164}
2078	63	32	{171}
2079	63	33	{178,173}
2080	64	1	{1}
2081	64	2	{6}
2082	64	3	{11}
2083	64	4	{16}
2084	64	5	{21}
2085	64	6	{26}
2086	64	7	{31}
2087	64	8	{36}
2088	64	9	{48,47,45}
2089	64	10	{50,56}
2090	64	11	{57}
2091	64	12	{63}
2092	64	13	{67}
2093	64	14	{72}
2094	64	15	{77}
2095	64	16	{83}
2096	64	17	{87}
2097	64	18	{92}
2098	64	19	{98}
2099	64	20	{102}
2100	64	21	{108}
2101	64	22	{112}
2102	64	23	{118}
2103	64	24	{122}
2104	64	25	{131}
2105	64	26	{135,136}
2106	64	27	{138}
2107	64	28	{143}
2108	64	29	{154,155}
2109	64	30	{160}
2110	64	31	{163,165}
2111	64	32	{170}
2112	64	33	{181,175,173}
2113	65	1	{2}
2114	65	2	{7}
2115	65	3	{12}
2116	65	4	{19}
2117	65	5	{22}
2118	65	6	{27}
2119	65	7	{35}
2120	65	8	{36}
2121	65	9	{46,47}
2122	65	10	{55}
2123	65	11	{61}
2124	65	12	{62}
2125	65	13	{67}
2126	65	14	{74}
2127	65	15	{77}
2128	65	16	{82}
2129	65	17	{87}
2130	65	18	{92}
2131	65	19	{97}
2132	65	20	{102}
2133	65	21	{108}
2134	65	22	{112}
2135	65	23	{117}
2136	65	24	{123}
2137	65	25	{127}
2138	65	26	{132,134,137}
2139	65	27	{138}
2140	65	28	{144}
2141	65	29	{153,150,149}
2142	65	30	{157}
2143	65	31	{167}
2144	65	32	{171}
2145	65	33	{177}
2146	66	1	{1}
2147	66	2	{6}
2148	66	3	{11}
2149	66	4	{16}
2150	66	5	{22}
2151	66	6	{26}
2152	66	7	{31}
2153	66	8	{36}
2154	66	9	{44,47}
2155	66	10	{53}
2156	66	11	{57}
2157	66	12	{64}
2158	66	13	{67}
2159	66	14	{72}
2160	66	15	{77}
2161	66	16	{86}
2162	66	17	{87}
2163	66	18	{93}
2164	66	19	{97}
2165	66	20	{102}
2166	66	21	{111}
2167	66	22	{113}
2168	66	23	{117}
2169	66	24	{122}
2170	66	25	{128}
2171	66	26	{132,135}
2172	66	27	{138}
2173	66	28	{143}
2174	66	29	{150,154}
2175	66	30	{156}
2176	66	31	{168}
2177	66	32	{172}
2178	66	33	{179,174,173}
2179	67	1	{1}
2180	67	2	{7}
2181	67	3	{11}
2182	67	4	{17}
2183	67	5	{21}
2184	67	6	{26}
2185	67	7	{31}
2186	67	8	{36}
2187	67	9	{48,44,43}
2188	67	10	{54,51}
2189	67	11	{60}
2190	67	12	{62}
2191	67	13	{67}
2192	67	14	{72}
2193	67	15	{77}
2194	67	16	{82}
2195	67	17	{87}
2196	67	18	{93}
2197	67	19	{98}
2198	67	20	{102}
2199	67	21	{108}
2200	67	22	{112}
2201	67	23	{117}
2202	67	24	{125}
2203	67	25	{127}
2204	67	26	{132}
2205	67	27	{139}
2206	67	28	{144}
2207	67	29	{153}
2208	67	30	{158}
2209	67	31	{161,169}
2210	67	32	{170}
2211	67	33	{174,177}
2212	68	1	{3}
2213	68	2	{9}
2214	68	3	{11}
2215	68	4	{16}
2216	68	5	{21}
2217	68	6	{26}
2218	68	7	{31}
2219	68	8	{36}
2220	68	9	{42,44,43}
2221	68	10	{51,55,56}
2222	68	11	{57}
2223	68	12	{62}
2224	68	13	{67}
2225	68	14	{72}
2226	68	15	{78}
2227	68	16	{82}
2228	68	17	{87}
2229	68	18	{92}
2230	68	19	{98}
2231	68	20	{106}
2232	68	21	{108}
2233	68	22	{112}
2234	68	23	{117}
2235	68	24	{122}
2236	68	25	{127}
2237	68	26	{134}
2238	68	27	{138}
2239	68	28	{143}
2240	68	29	{149,155}
2241	68	30	{159}
2242	68	31	{165}
2243	68	32	{172}
2244	68	33	{180}
2245	69	1	{3}
2246	69	2	{7}
2247	69	3	{12}
2248	69	4	{16}
2249	69	5	{24}
2250	69	6	{26}
2251	69	7	{32}
2252	69	8	{36}
2253	69	9	{46,43,47}
2254	69	10	{54,51,56}
2255	69	11	{57}
2256	69	12	{62}
2257	69	13	{67}
2258	69	14	{75}
2259	69	15	{77}
2260	69	16	{82}
2261	69	17	{87}
2262	69	18	{92}
2263	69	19	{98}
2264	69	20	{102}
2265	69	21	{108}
2266	69	22	{115}
2267	69	23	{121}
2268	69	24	{123}
2269	69	25	{128}
2270	69	26	{132,135,136}
2271	69	27	{138}
2272	69	28	{143}
2273	69	29	{153,149,154}
2274	69	30	{157}
2275	69	31	{167}
2276	69	32	{171}
2277	69	33	{179,176,180}
2278	70	1	{2}
2279	70	2	{6}
2280	70	3	{11}
2281	70	4	{16}
2282	70	5	{21}
2283	70	6	{27}
2284	70	7	{32}
2285	70	8	{36}
2286	70	9	{48}
2287	70	10	{50,55,49}
2288	70	11	{57}
2289	70	12	{63}
2290	70	13	{68}
2291	70	14	{72}
2292	70	15	{77}
2293	70	16	{82}
2294	70	17	{87}
2295	70	18	{92}
2296	70	19	{100}
2297	70	20	{103}
2298	70	21	{108}
2299	70	22	{112}
2300	70	23	{118}
2301	70	24	{122}
2302	70	25	{128}
2303	70	26	{132,136}
2304	70	27	{138}
2305	70	28	{144}
2306	70	29	{152,154}
2307	70	30	{159}
2308	70	31	{169}
2309	70	32	{170}
2310	70	33	{176}
2311	71	1	{1}
2312	71	2	{7}
2313	71	3	{13}
2314	71	4	{16}
2315	71	5	{21}
2316	71	6	{29}
2317	71	7	{32}
2318	71	8	{36}
2319	71	9	{42,41,45}
2320	71	10	{56}
2321	71	11	{58}
2322	71	12	{62}
2323	71	13	{67}
2324	71	14	{74}
2325	71	15	{77}
2326	71	16	{82}
2327	71	17	{88}
2328	71	18	{93}
2329	71	19	{98}
2330	71	20	{106}
2331	71	21	{111}
2332	71	22	{112}
2333	71	23	{118}
2334	71	24	{122}
2335	71	25	{128}
2336	71	26	{134,137}
2337	71	27	{138}
2338	71	28	{143}
2339	71	29	{151,148}
2340	71	30	{158}
2341	71	31	{167,166,168}
2342	71	32	{171}
2343	71	33	{179,181,176}
2344	72	1	{1}
2345	72	2	{7}
2346	72	3	{11}
2347	72	4	{16}
2348	72	5	{21}
2349	72	6	{26}
2350	72	7	{31}
2351	72	8	{37}
2352	72	9	{46,43,45}
2353	72	10	{53,50,56}
2354	72	11	{60}
2355	72	12	{62}
2356	72	13	{67}
2357	72	14	{73}
2358	72	15	{81}
2359	72	16	{82}
2360	72	17	{90}
2361	72	18	{92}
2362	72	19	{99}
2363	72	20	{102}
2364	72	21	{108}
2365	72	22	{112}
2366	72	23	{117}
2367	72	24	{122}
2368	72	25	{127}
2369	72	26	{133,136,137}
2370	72	27	{138}
2371	72	28	{144}
2372	72	29	{148,153}
2373	72	30	{158}
2374	72	31	{167}
2375	72	32	{172}
2376	72	33	{180}
2377	73	1	{4}
2378	73	2	{6}
2379	73	3	{11}
2380	73	4	{16}
2381	73	5	{23}
2382	73	6	{26}
2383	73	7	{31}
2384	73	8	{36}
2385	73	9	{41}
2386	73	10	{55}
2387	73	11	{59}
2388	73	12	{62}
2389	73	13	{67}
2390	73	14	{73}
2391	73	15	{77}
2392	73	16	{82}
2393	73	17	{90}
2394	73	18	{93}
2395	73	19	{97}
2396	73	20	{102}
2397	73	21	{108}
2398	73	22	{113}
2399	73	23	{117}
2400	73	24	{123}
2401	73	25	{127}
2402	73	26	{136}
2403	73	27	{138}
2404	73	28	{144}
2405	73	29	{153,152,155}
2406	73	30	{159}
2407	73	31	{163}
2408	73	32	{170}
2409	73	33	{180,177,173}
2410	74	1	{1}
2411	74	2	{6}
2412	74	3	{12}
2413	74	4	{19}
2414	74	5	{23}
2415	74	6	{26}
2416	74	7	{35}
2417	74	8	{36}
2418	74	9	{46,41}
2419	74	10	{54,50,55}
2420	74	11	{57}
2421	74	12	{62}
2422	74	13	{67}
2423	74	14	{72}
2424	74	15	{77}
2425	74	16	{82}
2426	74	17	{87}
2427	74	18	{93}
2428	74	19	{98}
2429	74	20	{102}
2430	74	21	{108}
2431	74	22	{112}
2432	74	23	{117}
2433	74	24	{123}
2434	74	25	{127}
2435	74	26	{132,137}
2436	74	27	{138}
2437	74	28	{144}
2438	74	29	{152}
2439	74	30	{158}
2440	74	31	{167,161}
2441	74	32	{170}
2442	74	33	{175,174,177}
2443	75	1	{1}
2444	75	2	{10}
2445	75	3	{14}
2446	75	4	{16}
2447	75	5	{21}
2448	75	6	{26}
2449	75	7	{32}
2450	75	8	{36}
2451	75	9	{48,43,45}
2452	75	10	{54,55,52}
2453	75	11	{57}
2454	75	12	{62}
2455	75	13	{68}
2456	75	14	{72}
2457	75	15	{78}
2458	75	16	{82}
2459	75	17	{87}
2460	75	18	{92}
2461	75	19	{97}
2462	75	20	{102}
2463	75	21	{108}
2464	75	22	{112}
2465	75	23	{120}
2466	75	24	{123}
2467	75	25	{128}
2468	75	26	{133,134}
2469	75	27	{139}
2470	75	28	{143}
2471	75	29	{152,150,149}
2472	75	30	{159}
2473	75	31	{168}
2474	75	32	{171}
2475	75	33	{175}
2476	76	1	{2}
2477	76	2	{9}
2478	76	3	{11}
2479	76	4	{16}
2480	76	5	{22}
2481	76	6	{30}
2482	76	7	{31}
2483	76	8	{36}
2484	76	9	{46,43,45}
2485	76	10	{53,55}
2486	76	11	{57}
2487	76	12	{62}
2488	76	13	{67}
2489	76	14	{72}
2490	76	15	{78}
2491	76	16	{82}
2492	76	17	{87}
2493	76	18	{92}
2494	76	19	{98}
2495	76	20	{102}
2496	76	21	{109}
2497	76	22	{112}
2498	76	23	{117}
2499	76	24	{122}
2500	76	25	{127}
2501	76	26	{132}
2502	76	27	{138}
2503	76	28	{144}
2504	76	29	{149,154,155}
2505	76	30	{160}
2506	76	31	{168,162}
2507	76	32	{170}
2508	76	33	{181,173}
2509	77	1	{1}
2510	77	2	{6}
2511	77	3	{11}
2512	77	4	{17}
2513	77	5	{21}
2514	77	6	{26}
2515	77	7	{31}
2516	77	8	{36}
2517	77	9	{42,46,41}
2518	77	10	{55,56,49}
2519	77	11	{57}
2520	77	12	{62}
2521	77	13	{67}
2522	77	14	{72}
2523	77	15	{77}
2524	77	16	{83}
2525	77	17	{89}
2526	77	18	{92}
2527	77	19	{97}
2528	77	20	{103}
2529	77	21	{108}
2530	77	22	{112}
2531	77	23	{118}
2532	77	24	{122}
2533	77	25	{127}
2534	77	26	{132,135,134}
2535	77	27	{138}
2536	77	28	{143}
2537	77	29	{148,154}
2538	77	30	{157}
2539	77	31	{166,168}
2540	77	32	{170}
2541	77	33	{175,174,173}
2542	78	1	{1}
2543	78	2	{6}
2544	78	3	{11}
2545	78	4	{16}
2546	78	5	{22}
2547	78	6	{27}
2548	78	7	{31}
2549	78	8	{36}
2550	78	9	{44,47}
2551	78	10	{54,50,51}
2552	78	11	{57}
2553	78	12	{62}
2554	78	13	{71}
2555	78	14	{72}
2556	78	15	{80}
2557	78	16	{83}
2558	78	17	{87}
2559	78	18	{92}
2560	78	19	{98}
2561	78	20	{102}
2562	78	21	{108}
2563	78	22	{116}
2564	78	23	{117}
2565	78	24	{122}
2566	78	25	{127}
2567	78	26	{133,134}
2568	78	27	{138}
2569	78	28	{143}
2570	78	29	{154}
2571	78	30	{159}
2572	78	31	{163,161,162}
2573	78	32	{170}
2574	78	33	{177}
2575	79	1	{1}
2576	79	2	{6}
2577	79	3	{12}
2578	79	4	{16}
2579	79	5	{21}
2580	79	6	{26}
2581	79	7	{31}
2582	79	8	{36}
2583	79	9	{42}
2584	79	10	{53}
2585	79	11	{57}
2586	79	12	{62}
2587	79	13	{70}
2588	79	14	{72}
2589	79	15	{77}
2590	79	16	{83}
2591	79	17	{87}
2592	79	18	{93}
2593	79	19	{97}
2594	79	20	{102}
2595	79	21	{108}
2596	79	22	{112}
2597	79	23	{117}
2598	79	24	{123}
2599	79	25	{127}
2600	79	26	{134,136,137}
2601	79	27	{138}
2602	79	28	{143}
2603	79	29	{155}
2604	79	30	{160}
2605	79	31	{163,165}
2606	79	32	{172}
2607	79	33	{177}
2608	80	1	{1}
2609	80	2	{6}
2610	80	3	{11}
2611	80	4	{17}
2612	80	5	{21}
2613	80	6	{26}
2614	80	7	{31}
2615	80	8	{36}
2616	80	9	{48,47}
2617	80	10	{53,49}
2618	80	11	{57}
2619	80	12	{63}
2620	80	13	{67}
2621	80	14	{72}
2622	80	15	{77}
2623	80	16	{82}
2624	80	17	{91}
2625	80	18	{92}
2626	80	19	{97}
2627	80	20	{102}
2628	80	21	{111}
2629	80	22	{114}
2630	80	23	{117}
2631	80	24	{122}
2632	80	25	{127}
2633	80	26	{137}
2634	80	27	{138}
2635	80	28	{147}
2636	80	29	{151,150}
2637	80	30	{157}
2638	80	31	{163,165}
2639	80	32	{171}
2640	80	33	{179}
2641	81	1	{1}
2642	81	2	{6}
2643	81	3	{11}
2644	81	4	{16}
2645	81	5	{21}
2646	81	6	{26}
2647	81	7	{31}
2648	81	8	{37}
2649	81	9	{46,41}
2650	81	10	{53,51,56}
2651	81	11	{57}
2652	81	12	{62}
2653	81	13	{68}
2654	81	14	{72}
2655	81	15	{77}
2656	81	16	{82}
2657	81	17	{88}
2658	81	18	{93}
2659	81	19	{98}
2660	81	20	{105}
2661	81	21	{108}
2662	81	22	{116}
2663	81	23	{117}
2664	81	24	{122}
2665	81	25	{127}
2666	81	26	{133,135,137}
2667	81	27	{138}
2668	81	28	{146}
2669	81	29	{152,150,155}
2670	81	30	{158}
2671	81	31	{167}
2672	81	32	{172}
2673	81	33	{180}
2674	82	1	{1}
2675	82	2	{6}
2676	82	3	{12}
2677	82	4	{16}
2678	82	5	{24}
2679	82	6	{26}
2680	82	7	{31}
2681	82	8	{36}
2682	82	9	{42,46,45}
2683	82	10	{52}
2684	82	11	{61}
2685	82	12	{63}
2686	82	13	{68}
2687	82	14	{72}
2688	82	15	{77}
2689	82	16	{82}
2690	82	17	{91}
2691	82	18	{92}
2692	82	19	{97}
2693	82	20	{105}
2694	82	21	{108}
2695	82	22	{112}
2696	82	23	{117}
2697	82	24	{122}
2698	82	25	{127}
2699	82	26	{133,132,135}
2700	82	27	{138}
2701	82	28	{144}
2702	82	29	{151}
2703	82	30	{156}
2704	82	31	{168}
2705	82	32	{172}
2706	82	33	{176,174}
2707	83	1	{1}
2708	83	2	{10}
2709	83	3	{11}
2710	83	4	{17}
2711	83	5	{21}
2712	83	6	{26}
2713	83	7	{31}
2714	83	8	{36}
2715	83	9	{48,46,44}
2716	83	10	{54,55}
2717	83	11	{57}
2718	83	12	{62}
2719	83	13	{67}
2720	83	14	{74}
2721	83	15	{77}
2722	83	16	{82}
2723	83	17	{91}
2724	83	18	{92}
2725	83	19	{97}
2726	83	20	{102}
2727	83	21	{108}
2728	83	22	{114}
2729	83	23	{117}
2730	83	24	{122}
2731	83	25	{127}
2732	83	26	{132}
2733	83	27	{138}
2734	83	28	{144}
2735	83	29	{151}
2736	83	30	{159}
2737	83	31	{161,169}
2738	83	32	{172}
2739	83	33	{173}
2740	84	1	{1}
2741	84	2	{6}
2742	84	3	{12}
2743	84	4	{16}
2744	84	5	{22}
2745	84	6	{26}
2746	84	7	{33}
2747	84	8	{36}
2748	84	9	{48,43,47}
2749	84	10	{54,52}
2750	84	11	{57}
2751	84	12	{63}
2752	84	13	{67}
2753	84	14	{73}
2754	84	15	{77}
2755	84	16	{83}
2756	84	17	{87}
2757	84	18	{92}
2758	84	19	{97}
2759	84	20	{102}
2760	84	21	{110}
2761	84	22	{112}
2762	84	23	{117}
2763	84	24	{122}
2764	84	25	{127}
2765	84	26	{132}
2766	84	27	{138}
2767	84	28	{143}
2768	84	29	{149,154,155}
2769	84	30	{158}
2770	84	31	{167,164}
2771	84	32	{172}
2772	84	33	{178}
2773	85	1	{1}
2774	85	2	{9}
2775	85	3	{11}
2776	85	4	{16}
2777	85	5	{21}
2778	85	6	{27}
2779	85	7	{31}
2780	85	8	{36}
2781	85	9	{46,41,47}
2782	85	10	{51,52}
2783	85	11	{57}
2784	85	12	{63}
2785	85	13	{67}
2786	85	14	{74}
2787	85	15	{77}
2788	85	16	{82}
2789	85	17	{91}
2790	85	18	{92}
2791	85	19	{98}
2792	85	20	{103}
2793	85	21	{108}
2794	85	22	{112}
2795	85	23	{117}
2796	85	24	{122}
2797	85	25	{127}
2798	85	26	{135}
2799	85	27	{138}
2800	85	28	{143}
2801	85	29	{148}
2802	85	30	{157}
2803	85	31	{162,165,164}
2804	85	32	{170}
2805	85	33	{176}
2806	86	1	{2}
2807	86	2	{6}
2808	86	3	{11}
2809	86	4	{16}
2810	86	5	{22}
2811	86	6	{26}
2812	86	7	{31}
2813	86	8	{40}
2814	86	9	{42,48,46}
2815	86	10	{49}
2816	86	11	{57}
2817	86	12	{62}
2818	86	13	{67}
2819	86	14	{74}
2820	86	15	{78}
2821	86	16	{84}
2822	86	17	{87}
2823	86	18	{92}
2824	86	19	{98}
2825	86	20	{102}
2826	86	21	{108}
2827	86	22	{112}
2828	86	23	{117}
2829	86	24	{122}
2830	86	25	{127}
2831	86	26	{135,136,137}
2832	86	27	{138}
2833	86	28	{143}
2834	86	29	{151,153}
2835	86	30	{160}
2836	86	31	{163,165,169}
2837	86	32	{170}
2838	86	33	{176}
2839	87	1	{5}
2840	87	2	{6}
2841	87	3	{11}
2842	87	4	{17}
2843	87	5	{25}
2844	87	6	{26}
2845	87	7	{31}
2846	87	8	{37}
2847	87	9	{43}
2848	87	10	{54,50,55}
2849	87	11	{57}
2850	87	12	{63}
2851	87	13	{68}
2852	87	14	{72}
2853	87	15	{77}
2854	87	16	{82}
2855	87	17	{87}
2856	87	18	{92}
2857	87	19	{97}
2858	87	20	{102}
2859	87	21	{109}
2860	87	22	{112}
2861	87	23	{117}
2862	87	24	{123}
2863	87	25	{127}
2864	87	26	{133,132,136}
2865	87	27	{138}
2866	87	28	{144}
2867	87	29	{152,150,155}
2868	87	30	{157}
2869	87	31	{162,165,164}
2870	87	32	{172}
2871	87	33	{178,177,173}
2872	88	1	{1}
2873	88	2	{6}
2874	88	3	{12}
2875	88	4	{16}
2876	88	5	{25}
2877	88	6	{26}
2878	88	7	{31}
2879	88	8	{36}
2880	88	9	{48,44}
2881	88	10	{55}
2882	88	11	{57}
2883	88	12	{63}
2884	88	13	{69}
2885	88	14	{72}
2886	88	15	{77}
2887	88	16	{82}
2888	88	17	{90}
2889	88	18	{93}
2890	88	19	{97}
2891	88	20	{103}
2892	88	21	{108}
2893	88	22	{112}
2894	88	23	{117}
2895	88	24	{122}
2896	88	25	{128}
2897	88	26	{132,135,137}
2898	88	27	{138}
2899	88	28	{146}
2900	88	29	{150}
2901	88	30	{156}
2902	88	31	{163,168}
2903	88	32	{172}
2904	88	33	{173}
2905	89	1	{1}
2906	89	2	{7}
2907	89	3	{11}
2908	89	4	{16}
2909	89	5	{23}
2910	89	6	{29}
2911	89	7	{31}
2912	89	8	{36}
2913	89	9	{46}
2914	89	10	{49}
2915	89	11	{57}
2916	89	12	{62}
2917	89	13	{67}
2918	89	14	{72}
2919	89	15	{77}
2920	89	16	{82}
2921	89	17	{87}
2922	89	18	{92}
2923	89	19	{97}
2924	89	20	{102}
2925	89	21	{108}
2926	89	22	{112}
2927	89	23	{118}
2928	89	24	{122}
2929	89	25	{128}
2930	89	26	{133}
2931	89	27	{138}
2932	89	28	{143}
2933	89	29	{153,152,150}
2934	89	30	{156}
2935	89	31	{161}
2936	89	32	{170}
2937	89	33	{179}
2938	90	1	{1}
2939	90	2	{7}
2940	90	3	{11}
2941	90	4	{16}
2942	90	5	{21}
2943	90	6	{26}
2944	90	7	{31}
2945	90	8	{36}
2946	90	9	{42}
2947	90	10	{50,51}
2948	90	11	{57}
2949	90	12	{63}
2950	90	13	{67}
2951	90	14	{72}
2952	90	15	{78}
2953	90	16	{82}
2954	90	17	{87}
2955	90	18	{92}
2956	90	19	{97}
2957	90	20	{103}
2958	90	21	{109}
2959	90	22	{113}
2960	90	23	{117}
2961	90	24	{123}
2962	90	25	{128}
2963	90	26	{135,134}
2964	90	27	{139}
2965	90	28	{143}
2966	90	29	{150}
2967	90	30	{157}
2968	90	31	{167,162}
2969	90	32	{170}
2970	90	33	{175,174}
2971	91	1	{2}
2972	91	2	{8}
2973	91	3	{12}
2974	91	4	{20}
2975	91	5	{21}
2976	91	6	{26}
2977	91	7	{32}
2978	91	8	{36}
2979	91	9	{42,48,47}
2980	91	10	{53,55,56}
2981	91	11	{57}
2982	91	12	{62}
2983	91	13	{67}
2984	91	14	{73}
2985	91	15	{77}
2986	91	16	{83}
2987	91	17	{87}
2988	91	18	{93}
2989	91	19	{97}
2990	91	20	{103}
2991	91	21	{108}
2992	91	22	{114}
2993	91	23	{118}
2994	91	24	{123}
2995	91	25	{130}
2996	91	26	{132,135,136}
2997	91	27	{138}
2998	91	28	{143}
2999	91	29	{148,154,155}
3000	91	30	{158}
3001	91	31	{168,161,162}
3002	91	32	{171}
3003	91	33	{177}
3004	92	1	{1}
3005	92	2	{6}
3006	92	3	{15}
3007	92	4	{16}
3008	92	5	{25}
3009	92	6	{27}
3010	92	7	{32}
3011	92	8	{36}
3012	92	9	{46,41}
3013	92	10	{56}
3014	92	11	{58}
3015	92	12	{63}
3016	92	13	{67}
3017	92	14	{74}
3018	92	15	{78}
3019	92	16	{86}
3020	92	17	{88}
3021	92	18	{92}
3022	92	19	{98}
3023	92	20	{102}
3024	92	21	{109}
3025	92	22	{113}
3026	92	23	{117}
3027	92	24	{122}
3028	92	25	{127}
3029	92	26	{133,134,136}
3030	92	27	{139}
3031	92	28	{143}
3032	92	29	{153,150}
3033	92	30	{159}
3034	92	31	{169}
3035	92	32	{170}
3036	92	33	{180}
3037	93	1	{1}
3038	93	2	{6}
3039	93	3	{11}
3040	93	4	{16}
3041	93	5	{21}
3042	93	6	{26}
3043	93	7	{31}
3044	93	8	{36}
3045	93	9	{46}
3046	93	10	{54,51,49}
3047	93	11	{57}
3048	93	12	{63}
3049	93	13	{67}
3050	93	14	{72}
3051	93	15	{77}
3052	93	16	{82}
3053	93	17	{87}
3054	93	18	{93}
3055	93	19	{97}
3056	93	20	{102}
3057	93	21	{108}
3058	93	22	{112}
3059	93	23	{117}
3060	93	24	{123}
3061	93	25	{128}
3062	93	26	{134,136,137}
3063	93	27	{138}
3064	93	28	{143}
3065	93	29	{148,149,154}
3066	93	30	{160}
3067	93	31	{163}
3068	93	32	{170}
3069	93	33	{177}
3070	94	1	{1}
3071	94	2	{6}
3072	94	3	{12}
3073	94	4	{17}
3074	94	5	{21}
3075	94	6	{27}
3076	94	7	{31}
3077	94	8	{36}
3078	94	9	{41,45}
3079	94	10	{53,49}
3080	94	11	{57}
3081	94	12	{66}
3082	94	13	{67}
3083	94	14	{72}
3084	94	15	{77}
3085	94	16	{82}
3086	94	17	{87}
3087	94	18	{95}
3088	94	19	{99}
3089	94	20	{102}
3090	94	21	{109}
3091	94	22	{113}
3092	94	23	{117}
3093	94	24	{122}
3094	94	25	{127}
3095	94	26	{135,136,137}
3096	94	27	{138}
3097	94	28	{143}
3098	94	29	{150,154}
3099	94	30	{160}
3100	94	31	{165,169}
3101	94	32	{171}
3102	94	33	{180}
3103	95	1	{1}
3104	95	2	{6}
3105	95	3	{12}
3106	95	4	{16}
3107	95	5	{21}
3108	95	6	{26}
3109	95	7	{32}
3110	95	8	{36}
3111	95	9	{42,41,45}
3112	95	10	{49}
3113	95	11	{58}
3114	95	12	{62}
3115	95	13	{67}
3116	95	14	{72}
3117	95	15	{78}
3118	95	16	{82}
3119	95	17	{87}
3120	95	18	{95}
3121	95	19	{98}
3122	95	20	{103}
3123	95	21	{108}
3124	95	22	{112}
3125	95	23	{117}
3126	95	24	{124}
3127	95	25	{127}
3128	95	26	{133,135,136}
3129	95	27	{139}
3130	95	28	{144}
3131	95	29	{155}
3132	95	30	{159}
3133	95	31	{166}
3134	95	32	{171}
3135	95	33	{177}
3136	96	1	{1}
3137	96	2	{6}
3138	96	3	{11}
3139	96	4	{16}
3140	96	5	{21}
3141	96	6	{26}
3142	96	7	{35}
3143	96	8	{36}
3144	96	9	{43}
3145	96	10	{50,52}
3146	96	11	{57}
3147	96	12	{62}
3148	96	13	{67}
3149	96	14	{72}
3150	96	15	{77}
3151	96	16	{82}
3152	96	17	{87}
3153	96	18	{93}
3154	96	19	{98}
3155	96	20	{103}
3156	96	21	{108}
3157	96	22	{112}
3158	96	23	{121}
3159	96	24	{123}
3160	96	25	{128}
3161	96	26	{132,135,134}
3162	96	27	{138}
3163	96	28	{143}
3164	96	29	{150,149}
3165	96	30	{156}
3166	96	31	{162}
3167	96	32	{170}
3168	96	33	{173}
3169	97	1	{1}
3170	97	2	{7}
3171	97	3	{11}
3172	97	4	{16}
3173	97	5	{21}
3174	97	6	{27}
3175	97	7	{31}
3176	97	8	{37}
3177	97	9	{46,47,45}
3178	97	10	{55,49}
3179	97	11	{57}
3180	97	12	{65}
3181	97	13	{70}
3182	97	14	{72}
3183	97	15	{77}
3184	97	16	{82}
3185	97	17	{88}
3186	97	18	{92}
3187	97	19	{98}
3188	97	20	{102}
3189	97	21	{108}
3190	97	22	{112}
3191	97	23	{117}
3192	97	24	{122}
3193	97	25	{127}
3194	97	26	{133,135,136}
3195	97	27	{139}
3196	97	28	{145}
3197	97	29	{152}
3198	97	30	{156}
3199	97	31	{163,166,161}
3200	97	32	{171}
3201	97	33	{174,173}
3202	98	1	{1}
3203	98	2	{6}
3204	98	3	{12}
3205	98	4	{17}
3206	98	5	{21}
3207	98	6	{26}
3208	98	7	{32}
3209	98	8	{40}
3210	98	9	{48,44}
3211	98	10	{49,52}
3212	98	11	{57}
3213	98	12	{62}
3214	98	13	{67}
3215	98	14	{72}
3216	98	15	{77}
3217	98	16	{82}
3218	98	17	{87}
3219	98	18	{93}
3220	98	19	{98}
3221	98	20	{102}
3222	98	21	{109}
3223	98	22	{112}
3224	98	23	{117}
3225	98	24	{122}
3226	98	25	{127}
3227	98	26	{135}
3228	98	27	{138}
3229	98	28	{143}
3230	98	29	{151,152,149}
3231	98	30	{160}
3232	98	31	{162,164}
3233	98	32	{171}
3234	98	33	{173}
3235	99	1	{2}
3236	99	2	{6}
3237	99	3	{11}
3238	99	4	{20}
3239	99	5	{22}
3240	99	6	{26}
3241	99	7	{31}
3242	99	8	{36}
3243	99	9	{43,41}
3244	99	10	{49}
3245	99	11	{57}
3246	99	12	{62}
3247	99	13	{67}
3248	99	14	{72}
3249	99	15	{80}
3250	99	16	{86}
3251	99	17	{87}
3252	99	18	{92}
3253	99	19	{101}
3254	99	20	{102}
3255	99	21	{108}
3256	99	22	{112}
3257	99	23	{120}
3258	99	24	{122}
3259	99	25	{131}
3260	99	26	{137}
3261	99	27	{141}
3262	99	28	{143}
3263	99	29	{151}
3264	99	30	{160}
3265	99	31	{163,166,165}
3266	99	32	{172}
3267	99	33	{178,181,180}
3268	100	1	{1}
3269	100	2	{6}
3270	100	3	{11}
3271	100	4	{16}
3272	100	5	{21}
3273	100	6	{26}
3274	100	7	{31}
3275	100	8	{37}
3276	100	9	{46,41,45}
3277	100	10	{50,49}
3278	100	11	{57}
3279	100	12	{62}
3280	100	13	{68}
3281	100	14	{72}
3282	100	15	{77}
3283	100	16	{83}
3284	100	17	{87}
3285	100	18	{92}
3286	100	19	{98}
3287	100	20	{103}
3288	100	21	{108}
3289	100	22	{112}
3290	100	23	{117}
3291	100	24	{122}
3292	100	25	{127}
3293	100	26	{133,136}
3294	100	27	{138}
3295	100	28	{143}
3296	100	29	{149}
3297	100	30	{159}
3298	100	31	{169}
3299	100	32	{172}
3300	100	33	{176}
3301	101	1	{3}
3302	101	2	{7}
3303	101	3	{15}
3304	101	4	{17}
3305	101	5	{22}
3306	101	6	{28}
3307	101	7	{32}
3308	101	8	{38}
3309	101	9	{43,47}
3310	101	10	{53,55,49}
3311	101	11	{58}
3312	101	12	{64}
3313	101	13	{68}
3314	101	14	{74}
3315	101	15	{78}
3316	101	16	{82}
3317	101	17	{88}
3318	101	18	{93}
3319	101	19	{97}
3320	101	20	{103}
3321	101	21	{109}
3322	101	22	{112}
3323	101	23	{118}
3324	101	24	{122}
3325	101	25	{128}
3326	101	26	{133,132}
3327	101	27	{140}
3328	101	28	{144}
3329	101	29	{151,149,154}
3330	101	30	{160}
3331	101	31	{165,164}
3332	101	32	{170}
3333	101	33	{178,174,177}
3334	102	1	{2}
3335	102	2	{6}
3336	102	3	{12}
3337	102	4	{17}
3338	102	5	{23}
3339	102	6	{27}
3340	102	7	{32}
3341	102	8	{37}
3342	102	9	{47}
3343	102	10	{55}
3344	102	11	{57}
3345	102	12	{62}
3346	102	13	{68}
3347	102	14	{74}
3348	102	15	{77}
3349	102	16	{84}
3350	102	17	{88}
3351	102	18	{93}
3352	102	19	{98}
3353	102	20	{104}
3354	102	21	{108}
3355	102	22	{112}
3356	102	23	{119}
3357	102	24	{123}
3358	102	25	{129}
3359	102	26	{133,132}
3360	102	27	{139}
3361	102	28	{145}
3362	102	29	{150}
3363	102	30	{160}
3364	102	31	{161,164}
3365	102	32	{172}
3366	102	33	{174}
3367	103	1	{3}
3368	103	2	{6}
3369	103	3	{12}
3370	103	4	{18}
3371	103	5	{23}
3372	103	6	{27}
3373	103	7	{33}
3374	103	8	{36}
3375	103	9	{46}
3376	103	10	{50,52}
3377	103	11	{59}
3378	103	12	{63}
3379	103	13	{68}
3380	103	14	{73}
3381	103	15	{79}
3382	103	16	{83}
3383	103	17	{88}
3384	103	18	{92}
3385	103	19	{98}
3386	103	20	{103}
3387	103	21	{109}
3388	103	22	{113}
3389	103	23	{119}
3390	103	24	{123}
3391	103	25	{128}
3392	103	26	{132,134,136}
3393	103	27	{139}
3394	103	28	{143}
3395	103	29	{153,155}
3396	103	30	{160}
3397	103	31	{163,162,165}
3398	103	32	{172}
3399	103	33	{176,180,174}
3400	104	1	{2}
3401	104	2	{10}
3402	104	3	{12}
3403	104	4	{17}
3404	104	5	{23}
3405	104	6	{26}
3406	104	7	{31}
3407	104	8	{39}
3408	104	9	{48,43,47}
3409	104	10	{54,56}
3410	104	11	{58}
3411	104	12	{63}
3412	104	13	{68}
3413	104	14	{72}
3414	104	15	{78}
3415	104	16	{84}
3416	104	17	{88}
3417	104	18	{92}
3418	104	19	{98}
3419	104	20	{104}
3420	104	21	{111}
3421	104	22	{113}
3422	104	23	{118}
3423	104	24	{122}
3424	104	25	{128}
3425	104	26	{134}
3426	104	27	{138}
3427	104	28	{144}
3428	104	29	{152,150}
3429	104	30	{157}
3430	104	31	{168,162}
3431	104	32	{172}
3432	104	33	{180}
3433	105	1	{2}
3434	105	2	{7}
3435	105	3	{11}
3436	105	4	{17}
3437	105	5	{22}
3438	105	6	{26}
3439	105	7	{32}
3440	105	8	{37}
3441	105	9	{42,46,41}
3442	105	10	{54}
3443	105	11	{57}
3444	105	12	{62}
3445	105	13	{68}
3446	105	14	{73}
3447	105	15	{78}
3448	105	16	{84}
3449	105	17	{88}
3450	105	18	{93}
3451	105	19	{98}
3452	105	20	{103}
3453	105	21	{108}
3454	105	22	{113}
3455	105	23	{120}
3456	105	24	{126}
3457	105	25	{129}
3458	105	26	{133,136}
3459	105	27	{139}
3460	105	28	{145}
3461	105	29	{154}
3462	105	30	{156}
3463	105	31	{169,164}
3464	105	32	{171}
3465	105	33	{181,173}
3466	106	1	{2}
3467	106	2	{7}
3468	106	3	{12}
3469	106	4	{17}
3470	106	5	{22}
3471	106	6	{27}
3472	106	7	{32}
3473	106	8	{37}
3474	106	9	{46,43}
3475	106	10	{49}
3476	106	11	{58}
3477	106	12	{63}
3478	106	13	{68}
3479	106	14	{73}
3480	106	15	{78}
3481	106	16	{83}
3482	106	17	{87}
3483	106	18	{93}
3484	106	19	{98}
3485	106	20	{103}
3486	106	21	{110}
3487	106	22	{114}
3488	106	23	{119}
3489	106	24	{122}
3490	106	25	{128}
3491	106	26	{134}
3492	106	27	{140}
3493	106	28	{143}
3494	106	29	{152,155}
3495	106	30	{156}
3496	106	31	{164}
3497	106	32	{170}
3498	106	33	{178,180,175}
3499	107	1	{2}
3500	107	2	{7}
3501	107	3	{12}
3502	107	4	{17}
3503	107	5	{22}
3504	107	6	{27}
3505	107	7	{34}
3506	107	8	{37}
3507	107	9	{47}
3508	107	10	{54,51,55}
3509	107	11	{58}
3510	107	12	{63}
3511	107	13	{69}
3512	107	14	{74}
3513	107	15	{78}
3514	107	16	{83}
3515	107	17	{88}
3516	107	18	{95}
3517	107	19	{98}
3518	107	20	{102}
3519	107	21	{109}
3520	107	22	{113}
3521	107	23	{118}
3522	107	24	{123}
3523	107	25	{128}
3524	107	26	{135}
3525	107	27	{140}
3526	107	28	{144}
3527	107	29	{151,155}
3528	107	30	{160}
3529	107	31	{167,165}
3530	107	32	{170}
3531	107	33	{179,181,175}
3532	108	1	{3}
3533	108	2	{10}
3534	108	3	{11}
3535	108	4	{18}
3536	108	5	{22}
3537	108	6	{28}
3538	108	7	{34}
3539	108	8	{36}
3540	108	9	{46,44,41}
3541	108	10	{55,56}
3542	108	11	{58}
3543	108	12	{64}
3544	108	13	{69}
3545	108	14	{73}
3546	108	15	{78}
3547	108	16	{83}
3548	108	17	{89}
3549	108	18	{92}
3550	108	19	{100}
3551	108	20	{102}
3552	108	21	{109}
3553	108	22	{112}
3554	108	23	{118}
3555	108	24	{122}
3556	108	25	{127}
3557	108	26	{132,135,134}
3558	108	27	{138}
3559	108	28	{145}
3560	108	29	{151,152,155}
3561	108	30	{160}
3562	108	31	{167,169}
3563	108	32	{170}
3564	108	33	{173}
3565	109	1	{5}
3566	109	2	{7}
3567	109	3	{12}
3568	109	4	{17}
3569	109	5	{22}
3570	109	6	{27}
3571	109	7	{33}
3572	109	8	{37}
3573	109	9	{45}
3574	109	10	{53}
3575	109	11	{58}
3576	109	12	{63}
3577	109	13	{67}
3578	109	14	{73}
3579	109	15	{78}
3580	109	16	{83}
3581	109	17	{88}
3582	109	18	{94}
3583	109	19	{97}
3584	109	20	{106}
3585	109	21	{109}
3586	109	22	{113}
3587	109	23	{118}
3588	109	24	{122}
3589	109	25	{128}
3590	109	26	{135,136}
3591	109	27	{139}
3592	109	28	{144}
3593	109	29	{149}
3594	109	30	{158}
3595	109	31	{168,169}
3596	109	32	{172}
3597	109	33	{178,179,181}
3598	110	1	{2}
3599	110	2	{7}
3600	110	3	{12}
3601	110	4	{17}
3602	110	5	{22}
3603	110	6	{26}
3604	110	7	{33}
3605	110	8	{38}
3606	110	9	{48,44,43}
3607	110	10	{53,51}
3608	110	11	{59}
3609	110	12	{64}
3610	110	13	{68}
3611	110	14	{73}
3612	110	15	{78}
3613	110	16	{83}
3614	110	17	{88}
3615	110	18	{93}
3616	110	19	{98}
3617	110	20	{104}
3618	110	21	{109}
3619	110	22	{113}
3620	110	23	{118}
3621	110	24	{123}
3622	110	25	{127}
3623	110	26	{133}
3624	110	27	{139}
3625	110	28	{143}
3626	110	29	{150,154}
3627	110	30	{157}
3628	110	31	{168,169}
3629	110	32	{172}
3630	110	33	{175,174,177}
3631	111	1	{2}
3632	111	2	{9}
3633	111	3	{11}
3634	111	4	{18}
3635	111	5	{25}
3636	111	6	{27}
3637	111	7	{32}
3638	111	8	{37}
3639	111	9	{42,43}
3640	111	10	{54,55}
3641	111	11	{57}
3642	111	12	{63}
3643	111	13	{68}
3644	111	14	{73}
3645	111	15	{79}
3646	111	16	{83}
3647	111	17	{87}
3648	111	18	{93}
3649	111	19	{97}
3650	111	20	{104}
3651	111	21	{109}
3652	111	22	{113}
3653	111	23	{118}
3654	111	24	{123}
3655	111	25	{128}
3656	111	26	{137}
3657	111	27	{139}
3658	111	28	{144}
3659	111	29	{153,152}
3660	111	30	{160}
3661	111	31	{167,166}
3662	111	32	{170}
3663	111	33	{173}
3664	112	1	{3}
3665	112	2	{7}
3666	112	3	{12}
3667	112	4	{16}
3668	112	5	{22}
3669	112	6	{27}
3670	112	7	{32}
3671	112	8	{37}
3672	112	9	{48,44,41}
3673	112	10	{50}
3674	112	11	{58}
3675	112	12	{62}
3676	112	13	{67}
3677	112	14	{72}
3678	112	15	{81}
3679	112	16	{83}
3680	112	17	{88}
3681	112	18	{94}
3682	112	19	{98}
3683	112	20	{103}
3684	112	21	{109}
3685	112	22	{113}
3686	112	23	{119}
3687	112	24	{123}
3688	112	25	{128}
3689	112	26	{135}
3690	112	27	{138}
3691	112	28	{144}
3692	112	29	{148,154}
3693	112	30	{159}
3694	112	31	{163,162,169}
3695	112	32	{171}
3696	112	33	{176}
3697	113	1	{2}
3698	113	2	{8}
3699	113	3	{12}
3700	113	4	{18}
3701	113	5	{22}
3702	113	6	{27}
3703	113	7	{32}
3704	113	8	{37}
3705	113	9	{42,45}
3706	113	10	{50,49}
3707	113	11	{58}
3708	113	12	{63}
3709	113	13	{67}
3710	113	14	{72}
3711	113	15	{78}
3712	113	16	{82}
3713	113	17	{88}
3714	113	18	{92}
3715	113	19	{98}
3716	113	20	{105}
3717	113	21	{109}
3718	113	22	{113}
3719	113	23	{118}
3720	113	24	{123}
3721	113	25	{129}
3722	113	26	{132}
3723	113	27	{139}
3724	113	28	{144}
3725	113	29	{148}
3726	113	30	{156}
3727	113	31	{163,166,164}
3728	113	32	{172}
3729	113	33	{179,176,180}
3730	114	1	{5}
3731	114	2	{7}
3732	114	3	{12}
3733	114	4	{17}
3734	114	5	{21}
3735	114	6	{30}
3736	114	7	{32}
3737	114	8	{36}
3738	114	9	{48,46,45}
3739	114	10	{50,55,52}
3740	114	11	{58}
3741	114	12	{63}
3742	114	13	{69}
3743	114	14	{73}
3744	114	15	{77}
3745	114	16	{83}
3746	114	17	{90}
3747	114	18	{93}
3748	114	19	{97}
3749	114	20	{103}
3750	114	21	{109}
3751	114	22	{114}
3752	114	23	{117}
3753	114	24	{124}
3754	114	25	{128}
3755	114	26	{135}
3756	114	27	{139}
3757	114	28	{144}
3758	114	29	{149}
3759	114	30	{160}
3760	114	31	{162,165,164}
3761	114	32	{172}
3762	114	33	{180,175,177}
3763	115	1	{2}
3764	115	2	{8}
3765	115	3	{12}
3766	115	4	{17}
3767	115	5	{22}
3768	115	6	{27}
3769	115	7	{31}
3770	115	8	{37}
3771	115	9	{46}
3772	115	10	{49}
3773	115	11	{58}
3774	115	12	{62}
3775	115	13	{67}
3776	115	14	{72}
3777	115	15	{78}
3778	115	16	{83}
3779	115	17	{88}
3780	115	18	{92}
3781	115	19	{99}
3782	115	20	{103}
3783	115	21	{111}
3784	115	22	{115}
3785	115	23	{119}
3786	115	24	{123}
3787	115	25	{127}
3788	115	26	{132,134,137}
3789	115	27	{139}
3790	115	28	{143}
3791	115	29	{150}
3792	115	30	{158}
3793	115	31	{169}
3794	115	32	{171}
3795	115	33	{174}
3796	116	1	{3}
3797	116	2	{7}
3798	116	3	{12}
3799	116	4	{17}
3800	116	5	{22}
3801	116	6	{27}
3802	116	7	{31}
3803	116	8	{38}
3804	116	9	{46,45}
3805	116	10	{53}
3806	116	11	{57}
3807	116	12	{64}
3808	116	13	{67}
3809	116	14	{73}
3810	116	15	{78}
3811	116	16	{84}
3812	116	17	{88}
3813	116	18	{94}
3814	116	19	{97}
3815	116	20	{103}
3816	116	21	{111}
3817	116	22	{113}
3818	116	23	{119}
3819	116	24	{123}
3820	116	25	{128}
3821	116	26	{135,136}
3822	116	27	{138}
3823	116	28	{143}
3824	116	29	{152,149}
3825	116	30	{160}
3826	116	31	{163,168,161}
3827	116	32	{171}
3828	116	33	{173}
3829	117	1	{2}
3830	117	2	{7}
3831	117	3	{13}
3832	117	4	{18}
3833	117	5	{22}
3834	117	6	{27}
3835	117	7	{31}
3836	117	8	{37}
3837	117	9	{45}
3838	117	10	{50,56}
3839	117	11	{58}
3840	117	12	{64}
3841	117	13	{67}
3842	117	14	{73}
3843	117	15	{77}
3844	117	16	{83}
3845	117	17	{88}
3846	117	18	{94}
3847	117	19	{97}
3848	117	20	{103}
3849	117	21	{109}
3850	117	22	{113}
3851	117	23	{118}
3852	117	24	{123}
3853	117	25	{128}
3854	117	26	{132}
3855	117	27	{139}
3856	117	28	{144}
3857	117	29	{152,150}
3858	117	30	{156}
3859	117	31	{168,161,169}
3860	117	32	{170}
3861	117	33	{178}
3862	118	1	{1}
3863	118	2	{7}
3864	118	3	{12}
3865	118	4	{17}
3866	118	5	{25}
3867	118	6	{26}
3868	118	7	{32}
3869	118	8	{36}
3870	118	9	{42,45}
3871	118	10	{54,49}
3872	118	11	{58}
3873	118	12	{64}
3874	118	13	{68}
3875	118	14	{74}
3876	118	15	{79}
3877	118	16	{83}
3878	118	17	{88}
3879	118	18	{93}
3880	118	19	{98}
3881	118	20	{103}
3882	118	21	{109}
3883	118	22	{112}
3884	118	23	{118}
3885	118	24	{124}
3886	118	25	{128}
3887	118	26	{133,132,135}
3888	118	27	{140}
3889	118	28	{144}
3890	118	29	{153}
3891	118	30	{158}
3892	118	31	{169}
3893	118	32	{172}
3894	118	33	{178,180,173}
3895	119	1	{3}
3896	119	2	{7}
3897	119	3	{12}
3898	119	4	{17}
3899	119	5	{21}
3900	119	6	{27}
3901	119	7	{33}
3902	119	8	{37}
3903	119	9	{46,45}
3904	119	10	{55}
3905	119	11	{60}
3906	119	12	{63}
3907	119	13	{68}
3908	119	14	{73}
3909	119	15	{79}
3910	119	16	{86}
3911	119	17	{88}
3912	119	18	{92}
3913	119	19	{98}
3914	119	20	{103}
3915	119	21	{110}
3916	119	22	{114}
3917	119	23	{119}
3918	119	24	{123}
3919	119	25	{128}
3920	119	26	{135,134,137}
3921	119	27	{138}
3922	119	28	{144}
3923	119	29	{151,155}
3924	119	30	{156}
3925	119	31	{167,166,161}
3926	119	32	{171}
3927	119	33	{178,176,173}
3928	120	1	{2}
3929	120	2	{8}
3930	120	3	{12}
3931	120	4	{20}
3932	120	5	{23}
3933	120	6	{28}
3934	120	7	{31}
3935	120	8	{37}
3936	120	9	{43}
3937	120	10	{55,49}
3938	120	11	{58}
3939	120	12	{63}
3940	120	13	{70}
3941	120	14	{73}
3942	120	15	{77}
3943	120	16	{83}
3944	120	17	{88}
3945	120	18	{94}
3946	120	19	{101}
3947	120	20	{103}
3948	120	21	{111}
3949	120	22	{115}
3950	120	23	{118}
3951	120	24	{122}
3952	120	25	{128}
3953	120	26	{132,135,134}
3954	120	27	{138}
3955	120	28	{144}
3956	120	29	{151,149,155}
3957	120	30	{160}
3958	120	31	{169}
3959	120	32	{171}
3960	120	33	{177}
3961	121	1	{2}
3962	121	2	{7}
3963	121	3	{11}
3964	121	4	{17}
3965	121	5	{22}
3966	121	6	{30}
3967	121	7	{32}
3968	121	8	{37}
3969	121	9	{41}
3970	121	10	{54,51}
3971	121	11	{59}
3972	121	12	{63}
3973	121	13	{68}
3974	121	14	{73}
3975	121	15	{78}
3976	121	16	{83}
3977	121	17	{89}
3978	121	18	{93}
3979	121	19	{99}
3980	121	20	{103}
3981	121	21	{109}
3982	121	22	{113}
3983	121	23	{118}
3984	121	24	{124}
3985	121	25	{128}
3986	121	26	{133,136,137}
3987	121	27	{139}
3988	121	28	{144}
3989	121	29	{152,154,155}
3990	121	30	{156}
3991	121	31	{167,161,169}
3992	121	32	{171}
3993	121	33	{175}
3994	122	1	{1}
3995	122	2	{7}
3996	122	3	{11}
3997	122	4	{17}
3998	122	5	{25}
3999	122	6	{27}
4000	122	7	{32}
4001	122	8	{37}
4002	122	9	{45}
4003	122	10	{54,50,49}
4004	122	11	{59}
4005	122	12	{63}
4006	122	13	{69}
4007	122	14	{73}
4008	122	15	{77}
4009	122	16	{83}
4010	122	17	{88}
4011	122	18	{94}
4012	122	19	{99}
4013	122	20	{103}
4014	122	21	{109}
4015	122	22	{112}
4016	122	23	{118}
4017	122	24	{123}
4018	122	25	{129}
4019	122	26	{133}
4020	122	27	{138}
4021	122	28	{144}
4022	122	29	{149}
4023	122	30	{160}
4024	122	31	{165,164}
4025	122	32	{172}
4026	122	33	{174}
4027	123	1	{2}
4028	123	2	{6}
4029	123	3	{13}
4030	123	4	{17}
4031	123	5	{23}
4032	123	6	{27}
4033	123	7	{33}
4034	123	8	{37}
4035	123	9	{45}
4036	123	10	{53,51}
4037	123	11	{58}
4038	123	12	{63}
4039	123	13	{68}
4040	123	14	{72}
4041	123	15	{77}
4042	123	16	{84}
4043	123	17	{89}
4044	123	18	{93}
4045	123	19	{98}
4046	123	20	{103}
4047	123	21	{109}
4048	123	22	{113}
4049	123	23	{118}
4050	123	24	{123}
4051	123	25	{128}
4052	123	26	{132,135,137}
4053	123	27	{139}
4054	123	28	{145}
4055	123	29	{153}
4056	123	30	{157}
4057	123	31	{168,162,165}
4058	123	32	{172}
4059	123	33	{178,179}
4060	124	1	{2}
4061	124	2	{7}
4062	124	3	{12}
4063	124	4	{18}
4064	124	5	{23}
4065	124	6	{28}
4066	124	7	{32}
4067	124	8	{38}
4068	124	9	{41}
4069	124	10	{53}
4070	124	11	{57}
4071	124	12	{64}
4072	124	13	{67}
4073	124	14	{73}
4074	124	15	{78}
4075	124	16	{83}
4076	124	17	{87}
4077	124	18	{93}
4078	124	19	{98}
4079	124	20	{104}
4080	124	21	{110}
4081	124	22	{114}
4082	124	23	{118}
4083	124	24	{124}
4084	124	25	{128}
4085	124	26	{135,136}
4086	124	27	{139}
4087	124	28	{144}
4088	124	29	{151,152}
4089	124	30	{156}
4090	124	31	{167,165}
4091	124	32	{170}
4092	124	33	{179,176,174}
4093	125	1	{2}
4094	125	2	{10}
4095	125	3	{11}
4096	125	4	{17}
4097	125	5	{23}
4098	125	6	{27}
4099	125	7	{32}
4100	125	8	{38}
4101	125	9	{47}
4102	125	10	{54}
4103	125	11	{58}
4104	125	12	{63}
4105	125	13	{68}
4106	125	14	{72}
4107	125	15	{78}
4108	125	16	{83}
4109	125	17	{88}
4110	125	18	{95}
4111	125	19	{98}
4112	125	20	{103}
4113	125	21	{109}
4114	125	22	{114}
4115	125	23	{117}
4116	125	24	{123}
4117	125	25	{128}
4118	125	26	{135}
4119	125	27	{139}
4120	125	28	{144}
4121	125	29	{151,148,152}
4122	125	30	{158}
4123	125	31	{163,161}
4124	125	32	{171}
4125	125	33	{179,175,173}
4126	126	1	{2}
4127	126	2	{7}
4128	126	3	{12}
4129	126	4	{17}
4130	126	5	{22}
4131	126	6	{27}
4132	126	7	{33}
4133	126	8	{37}
4134	126	9	{46,47}
4135	126	10	{54,53,55}
4136	126	11	{58}
4137	126	12	{64}
4138	126	13	{68}
4139	126	14	{73}
4140	126	15	{79}
4141	126	16	{83}
4142	126	17	{87}
4143	126	18	{93}
4144	126	19	{99}
4145	126	20	{103}
4146	126	21	{109}
4147	126	22	{113}
4148	126	23	{117}
4149	126	24	{123}
4150	126	25	{131}
4151	126	26	{132,135}
4152	126	27	{139}
4153	126	28	{144}
4154	126	29	{152,150}
4155	126	30	{158}
4156	126	31	{166,168}
4157	126	32	{172}
4158	126	33	{177}
4159	127	1	{1}
4160	127	2	{8}
4161	127	3	{12}
4162	127	4	{18}
4163	127	5	{23}
4164	127	6	{27}
4165	127	7	{32}
4166	127	8	{37}
4167	127	9	{46,43,45}
4168	127	10	{54}
4169	127	11	{58}
4170	127	12	{62}
4171	127	13	{70}
4172	127	14	{74}
4173	127	15	{78}
4174	127	16	{83}
4175	127	17	{88}
4176	127	18	{93}
4177	127	19	{99}
4178	127	20	{103}
4179	127	21	{109}
4180	127	22	{113}
4181	127	23	{119}
4182	127	24	{123}
4183	127	25	{128}
4184	127	26	{134,136,137}
4185	127	27	{139}
4186	127	28	{145}
4187	127	29	{153,152}
4188	127	30	{158}
4189	127	31	{164}
4190	127	32	{171}
4191	127	33	{181,176}
4192	128	1	{2}
4193	128	2	{8}
4194	128	3	{12}
4195	128	4	{17}
4196	128	5	{22}
4197	128	6	{28}
4198	128	7	{32}
4199	128	8	{36}
4200	128	9	{42}
4201	128	10	{54,51,56}
4202	128	11	{57}
4203	128	12	{63}
4204	128	13	{68}
4205	128	14	{73}
4206	128	15	{78}
4207	128	16	{83}
4208	128	17	{88}
4209	128	18	{93}
4210	128	19	{97}
4211	128	20	{103}
4212	128	21	{109}
4213	128	22	{114}
4214	128	23	{121}
4215	128	24	{123}
4216	128	25	{128}
4217	128	26	{133}
4218	128	27	{139}
4219	128	28	{144}
4220	128	29	{154}
4221	128	30	{156}
4222	128	31	{162}
4223	128	32	{170}
4224	128	33	{178,173}
4225	129	1	{2}
4226	129	2	{7}
4227	129	3	{13}
4228	129	4	{17}
4229	129	5	{23}
4230	129	6	{27}
4231	129	7	{32}
4232	129	8	{38}
4233	129	9	{42,48,46}
4234	129	10	{54}
4235	129	11	{58}
4236	129	12	{63}
4237	129	13	{68}
4238	129	14	{73}
4239	129	15	{78}
4240	129	16	{83}
4241	129	17	{89}
4242	129	18	{93}
4243	129	19	{98}
4244	129	20	{103}
4245	129	21	{109}
4246	129	22	{113}
4247	129	23	{118}
4248	129	24	{123}
4249	129	25	{129}
4250	129	26	{133,137}
4251	129	27	{138}
4252	129	28	{144}
4253	129	29	{152}
4254	129	30	{156}
4255	129	31	{163,166,161}
4256	129	32	{170}
4257	129	33	{178,176,174}
4258	130	1	{2}
4259	130	2	{6}
4260	130	3	{12}
4261	130	4	{17}
4262	130	5	{22}
4263	130	6	{27}
4264	130	7	{33}
4265	130	8	{37}
4266	130	9	{42}
4267	130	10	{53,50,52}
4268	130	11	{58}
4269	130	12	{63}
4270	130	13	{68}
4271	130	14	{74}
4272	130	15	{78}
4273	130	16	{83}
4274	130	17	{88}
4275	130	18	{93}
4276	130	19	{98}
4277	130	20	{102}
4278	130	21	{109}
4279	130	22	{113}
4280	130	23	{121}
4281	130	24	{122}
4282	130	25	{128}
4283	130	26	{135,137}
4284	130	27	{139}
4285	130	28	{145}
4286	130	29	{151,150}
4287	130	30	{158}
4288	130	31	{168}
4289	130	32	{170}
4290	130	33	{178,181,175}
4291	131	1	{2}
4292	131	2	{6}
4293	131	3	{12}
4294	131	4	{16}
4295	131	5	{22}
4296	131	6	{27}
4297	131	7	{32}
4298	131	8	{37}
4299	131	9	{48}
4300	131	10	{51,52}
4301	131	11	{57}
4302	131	12	{63}
4303	131	13	{67}
4304	131	14	{74}
4305	131	15	{78}
4306	131	16	{82}
4307	131	17	{88}
4308	131	18	{93}
4309	131	19	{98}
4310	131	20	{106}
4311	131	21	{109}
4312	131	22	{113}
4313	131	23	{118}
4314	131	24	{122}
4315	131	25	{127}
4316	131	26	{133,136}
4317	131	27	{138}
4318	131	28	{144}
4319	131	29	{151,150}
4320	131	30	{158}
4321	131	31	{167,168}
4322	131	32	{171}
4323	131	33	{180,177}
4324	132	1	{2}
4325	132	2	{7}
4326	132	3	{12}
4327	132	4	{16}
4328	132	5	{22}
4329	132	6	{27}
4330	132	7	{31}
4331	132	8	{37}
4332	132	9	{41}
4333	132	10	{50,56}
4334	132	11	{58}
4335	132	12	{63}
4336	132	13	{68}
4337	132	14	{76}
4338	132	15	{78}
4339	132	16	{83}
4340	132	17	{89}
4341	132	18	{93}
4342	132	19	{98}
4343	132	20	{103}
4344	132	21	{109}
4345	132	22	{115}
4346	132	23	{118}
4347	132	24	{123}
4348	132	25	{128}
4349	132	26	{132,137}
4350	132	27	{141}
4351	132	28	{144}
4352	132	29	{155}
4353	132	30	{159}
4354	132	31	{165,169}
4355	132	32	{171}
4356	132	33	{179,181,175}
4357	133	1	{3}
4358	133	2	{7}
4359	133	3	{12}
4360	133	4	{20}
4361	133	5	{25}
4362	133	6	{27}
4363	133	7	{33}
4364	133	8	{38}
4365	133	9	{48,43,41}
4366	133	10	{56}
4367	133	11	{57}
4368	133	12	{64}
4369	133	13	{68}
4370	133	14	{73}
4371	133	15	{78}
4372	133	16	{85}
4373	133	17	{88}
4374	133	18	{94}
4375	133	19	{97}
4376	133	20	{103}
4377	133	21	{108}
4378	133	22	{113}
4379	133	23	{117}
4380	133	24	{123}
4381	133	25	{128}
4382	133	26	{134}
4383	133	27	{139}
4384	133	28	{144}
4385	133	29	{148,155}
4386	133	30	{160}
4387	133	31	{161,162,164}
4388	133	32	{172}
4389	133	33	{175,174}
4390	134	1	{2}
4391	134	2	{7}
4392	134	3	{13}
4393	134	4	{16}
4394	134	5	{22}
4395	134	6	{27}
4396	134	7	{32}
4397	134	8	{36}
4398	134	9	{44,47}
4399	134	10	{51,52}
4400	134	11	{58}
4401	134	12	{63}
4402	134	13	{68}
4403	134	14	{72}
4404	134	15	{81}
4405	134	16	{83}
4406	134	17	{91}
4407	134	18	{95}
4408	134	19	{97}
4409	134	20	{102}
4410	134	21	{109}
4411	134	22	{113}
4412	134	23	{119}
4413	134	24	{123}
4414	134	25	{128}
4415	134	26	{134}
4416	134	27	{138}
4417	134	28	{144}
4418	134	29	{154}
4419	134	30	{160}
4420	134	31	{167}
4421	134	32	{171}
4422	134	33	{176,175,173}
4423	135	1	{2}
4424	135	2	{6}
4425	135	3	{12}
4426	135	4	{20}
4427	135	5	{22}
4428	135	6	{27}
4429	135	7	{32}
4430	135	8	{37}
4431	135	9	{42,48,43}
4432	135	10	{54,55}
4433	135	11	{59}
4434	135	12	{63}
4435	135	13	{67}
4436	135	14	{72}
4437	135	15	{78}
4438	135	16	{83}
4439	135	17	{89}
4440	135	18	{92}
4441	135	19	{98}
4442	135	20	{103}
4443	135	21	{111}
4444	135	22	{112}
4445	135	23	{118}
4446	135	24	{123}
4447	135	25	{127}
4448	135	26	{132,136}
4449	135	27	{140}
4450	135	28	{144}
4451	135	29	{151,150}
4452	135	30	{159}
4453	135	31	{167}
4454	135	32	{170}
4455	135	33	{179}
4456	136	1	{2}
4457	136	2	{7}
4458	136	3	{12}
4459	136	4	{17}
4460	136	5	{21}
4461	136	6	{27}
4462	136	7	{33}
4463	136	8	{36}
4464	136	9	{45}
4465	136	10	{52}
4466	136	11	{59}
4467	136	12	{62}
4468	136	13	{67}
4469	136	14	{73}
4470	136	15	{81}
4471	136	16	{83}
4472	136	17	{88}
4473	136	18	{93}
4474	136	19	{99}
4475	136	20	{102}
4476	136	21	{109}
4477	136	22	{113}
4478	136	23	{117}
4479	136	24	{123}
4480	136	25	{128}
4481	136	26	{132,136,137}
4482	136	27	{139}
4483	136	28	{144}
4484	136	29	{148,153}
4485	136	30	{158}
4486	136	31	{166,162}
4487	136	32	{170}
4488	136	33	{178,175,177}
4489	137	1	{2}
4490	137	2	{7}
4491	137	3	{11}
4492	137	4	{17}
4493	137	5	{23}
4494	137	6	{28}
4495	137	7	{33}
4496	137	8	{37}
4497	137	9	{42}
4498	137	10	{53,56}
4499	137	11	{57}
4500	137	12	{63}
4501	137	13	{67}
4502	137	14	{74}
4503	137	15	{78}
4504	137	16	{84}
4505	137	17	{89}
4506	137	18	{93}
4507	137	19	{98}
4508	137	20	{102}
4509	137	21	{110}
4510	137	22	{114}
4511	137	23	{118}
4512	137	24	{123}
4513	137	25	{127}
4514	137	26	{133,132,135}
4515	137	27	{139}
4516	137	28	{143}
4517	137	29	{148,153}
4518	137	30	{156}
4519	137	31	{161,169,164}
4520	137	32	{171}
4521	137	33	{177}
4522	138	1	{3}
4523	138	2	{7}
4524	138	3	{12}
4525	138	4	{16}
4526	138	5	{22}
4527	138	6	{26}
4528	138	7	{32}
4529	138	8	{37}
4530	138	9	{44,41,45}
4531	138	10	{50,51,55}
4532	138	11	{58}
4533	138	12	{64}
4534	138	13	{68}
4535	138	14	{73}
4536	138	15	{78}
4537	138	16	{83}
4538	138	17	{88}
4539	138	18	{93}
4540	138	19	{99}
4541	138	20	{102}
4542	138	21	{109}
4543	138	22	{113}
4544	138	23	{118}
4545	138	24	{122}
4546	138	25	{128}
4547	138	26	{133}
4548	138	27	{139}
4549	138	28	{144}
4550	138	29	{149,154,155}
4551	138	30	{158}
4552	138	31	{167,166}
4553	138	32	{170}
4554	138	33	{181,180,173}
4555	139	1	{1}
4556	139	2	{7}
4557	139	3	{13}
4558	139	4	{16}
4559	139	5	{22}
4560	139	6	{27}
4561	139	7	{32}
4562	139	8	{36}
4563	139	9	{42,44,43}
4564	139	10	{55,56}
4565	139	11	{61}
4566	139	12	{62}
4567	139	13	{69}
4568	139	14	{73}
4569	139	15	{78}
4570	139	16	{83}
4571	139	17	{87}
4572	139	18	{93}
4573	139	19	{99}
4574	139	20	{104}
4575	139	21	{109}
4576	139	22	{113}
4577	139	23	{118}
4578	139	24	{123}
4579	139	25	{128}
4580	139	26	{135,136}
4581	139	27	{139}
4582	139	28	{145}
4583	139	29	{148,149,154}
4584	139	30	{160}
4585	139	31	{168,164}
4586	139	32	{171}
4587	139	33	{181}
4588	140	1	{2}
4589	140	2	{9}
4590	140	3	{12}
4591	140	4	{17}
4592	140	5	{21}
4593	140	6	{28}
4594	140	7	{32}
4595	140	8	{36}
4596	140	9	{42,44,47}
4597	140	10	{51,55,52}
4598	140	11	{58}
4599	140	12	{63}
4600	140	13	{68}
4601	140	14	{73}
4602	140	15	{78}
4603	140	16	{83}
4604	140	17	{89}
4605	140	18	{93}
4606	140	19	{99}
4607	140	20	{102}
4608	140	21	{110}
4609	140	22	{113}
4610	140	23	{120}
4611	140	24	{123}
4612	140	25	{129}
4613	140	26	{133,134,136}
4614	140	27	{139}
4615	140	28	{144}
4616	140	29	{151,155}
4617	140	30	{159}
4618	140	31	{168,165}
4619	140	32	{170}
4620	140	33	{176,174}
4621	141	1	{2}
4622	141	2	{7}
4623	141	3	{13}
4624	141	4	{16}
4625	141	5	{23}
4626	141	6	{26}
4627	141	7	{32}
4628	141	8	{37}
4629	141	9	{46}
4630	141	10	{55,52}
4631	141	11	{58}
4632	141	12	{62}
4633	141	13	{68}
4634	141	14	{73}
4635	141	15	{78}
4636	141	16	{83}
4637	141	17	{88}
4638	141	18	{93}
4639	141	19	{98}
4640	141	20	{104}
4641	141	21	{109}
4642	141	22	{112}
4643	141	23	{118}
4644	141	24	{122}
4645	141	25	{129}
4646	141	26	{135}
4647	141	27	{139}
4648	141	28	{144}
4649	141	29	{154}
4650	141	30	{158}
4651	141	31	{166,161,169}
4652	141	32	{170}
4653	141	33	{179,177}
4654	142	1	{3}
4655	142	2	{7}
4656	142	3	{11}
4657	142	4	{18}
4658	142	5	{21}
4659	142	6	{27}
4660	142	7	{32}
4661	142	8	{37}
4662	142	9	{45}
4663	142	10	{53,50,51}
4664	142	11	{58}
4665	142	12	{63}
4666	142	13	{69}
4667	142	14	{73}
4668	142	15	{78}
4669	142	16	{83}
4670	142	17	{88}
4671	142	18	{93}
4672	142	19	{97}
4673	142	20	{103}
4674	142	21	{109}
4675	142	22	{114}
4676	142	23	{118}
4677	142	24	{123}
4678	142	25	{128}
4679	142	26	{135,137}
4680	142	27	{140}
4681	142	28	{145}
4682	142	29	{152}
4683	142	30	{158}
4684	142	31	{166,169}
4685	142	32	{171}
4686	142	33	{176,180,175}
4687	143	1	{1}
4688	143	2	{7}
4689	143	3	{12}
4690	143	4	{17}
4691	143	5	{22}
4692	143	6	{27}
4693	143	7	{33}
4694	143	8	{37}
4695	143	9	{48,41,45}
4696	143	10	{54,56}
4697	143	11	{58}
4698	143	12	{63}
4699	143	13	{68}
4700	143	14	{74}
4701	143	15	{77}
4702	143	16	{82}
4703	143	17	{87}
4704	143	18	{95}
4705	143	19	{97}
4706	143	20	{103}
4707	143	21	{110}
4708	143	22	{113}
4709	143	23	{118}
4710	143	24	{124}
4711	143	25	{127}
4712	143	26	{134}
4713	143	27	{139}
4714	143	28	{146}
4715	143	29	{155}
4716	143	30	{157}
4717	143	31	{165}
4718	143	32	{170}
4719	143	33	{179,181}
4720	144	1	{2}
4721	144	2	{8}
4722	144	3	{12}
4723	144	4	{18}
4724	144	5	{22}
4725	144	6	{28}
4726	144	7	{32}
4727	144	8	{37}
4728	144	9	{44}
4729	144	10	{56,49}
4730	144	11	{58}
4731	144	12	{62}
4732	144	13	{69}
4733	144	14	{75}
4734	144	15	{79}
4735	144	16	{84}
4736	144	17	{89}
4737	144	18	{94}
4738	144	19	{100}
4739	144	20	{103}
4740	144	21	{109}
4741	144	22	{113}
4742	144	23	{118}
4743	144	24	{123}
4744	144	25	{129}
4745	144	26	{132,134,137}
4746	144	27	{138}
4747	144	28	{143}
4748	144	29	{152,150,155}
4749	144	30	{157}
4750	144	31	{163,161,169}
4751	144	32	{170}
4752	144	33	{175,174}
4753	145	1	{2}
4754	145	2	{7}
4755	145	3	{12}
4756	145	4	{16}
4757	145	5	{21}
4758	145	6	{27}
4759	145	7	{32}
4760	145	8	{38}
4761	145	9	{43}
4762	145	10	{50,55,56}
4763	145	11	{58}
4764	145	12	{64}
4765	145	13	{68}
4766	145	14	{72}
4767	145	15	{78}
4768	145	16	{83}
4769	145	17	{89}
4770	145	18	{93}
4771	145	19	{98}
4772	145	20	{102}
4773	145	21	{110}
4774	145	22	{114}
4775	145	23	{118}
4776	145	24	{126}
4777	145	25	{128}
4778	145	26	{133,136,137}
4779	145	27	{139}
4780	145	28	{144}
4781	145	29	{153}
4782	145	30	{156}
4783	145	31	{163,164}
4784	145	32	{170}
4785	145	33	{181}
4786	146	1	{3}
4787	146	2	{9}
4788	146	3	{12}
4789	146	4	{18}
4790	146	5	{22}
4791	146	6	{27}
4792	146	7	{32}
4793	146	8	{38}
4794	146	9	{43,47}
4795	146	10	{53,55,56}
4796	146	11	{57}
4797	146	12	{64}
4798	146	13	{68}
4799	146	14	{73}
4800	146	15	{79}
4801	146	16	{82}
4802	146	17	{88}
4803	146	18	{93}
4804	146	19	{98}
4805	146	20	{103}
4806	146	21	{109}
4807	146	22	{113}
4808	146	23	{118}
4809	146	24	{123}
4810	146	25	{127}
4811	146	26	{132,134}
4812	146	27	{139}
4813	146	28	{143}
4814	146	29	{148,150}
4815	146	30	{159}
4816	146	31	{163,162}
4817	146	32	{170}
4818	146	33	{176,174,177}
4819	147	1	{2}
4820	147	2	{7}
4821	147	3	{12}
4822	147	4	{17}
4823	147	5	{22}
4824	147	6	{27}
4825	147	7	{33}
4826	147	8	{36}
4827	147	9	{44}
4828	147	10	{53,50,55}
4829	147	11	{58}
4830	147	12	{62}
4831	147	13	{68}
4832	147	14	{73}
4833	147	15	{78}
4834	147	16	{82}
4835	147	17	{89}
4836	147	18	{93}
4837	147	19	{98}
4838	147	20	{103}
4839	147	21	{108}
4840	147	22	{113}
4841	147	23	{118}
4842	147	24	{124}
4843	147	25	{127}
4844	147	26	{132,135,137}
4845	147	27	{139}
4846	147	28	{144}
4847	147	29	{153,150,149}
4848	147	30	{159}
4849	147	31	{168,165}
4850	147	32	{172}
4851	147	33	{176,174}
4852	148	1	{2}
4853	148	2	{7}
4854	148	3	{12}
4855	148	4	{17}
4856	148	5	{22}
4857	148	6	{28}
4858	148	7	{35}
4859	148	8	{36}
4860	148	9	{42,46,45}
4861	148	10	{56}
4862	148	11	{58}
4863	148	12	{63}
4864	148	13	{68}
4865	148	14	{72}
4866	148	15	{78}
4867	148	16	{83}
4868	148	17	{88}
4869	148	18	{94}
4870	148	19	{98}
4871	148	20	{102}
4872	148	21	{109}
4873	148	22	{113}
4874	148	23	{118}
4875	148	24	{123}
4876	148	25	{129}
4877	148	26	{135}
4878	148	27	{139}
4879	148	28	{146}
4880	148	29	{151}
4881	148	30	{157}
4882	148	31	{163}
4883	148	32	{171}
4884	148	33	{180}
4885	149	1	{3}
4886	149	2	{7}
4887	149	3	{12}
4888	149	4	{17}
4889	149	5	{25}
4890	149	6	{28}
4891	149	7	{32}
4892	149	8	{37}
4893	149	9	{43,45}
4894	149	10	{49}
4895	149	11	{58}
4896	149	12	{63}
4897	149	13	{68}
4898	149	14	{74}
4899	149	15	{79}
4900	149	16	{82}
4901	149	17	{87}
4902	149	18	{95}
4903	149	19	{98}
4904	149	20	{103}
4905	149	21	{109}
4906	149	22	{113}
4907	149	23	{117}
4908	149	24	{123}
4909	149	25	{128}
4910	149	26	{135,136}
4911	149	27	{139}
4912	149	28	{144}
4913	149	29	{151,149}
4914	149	30	{159}
4915	149	31	{163,167,161}
4916	149	32	{172}
4917	149	33	{175,177}
4918	150	1	{1}
4919	150	2	{7}
4920	150	3	{12}
4921	150	4	{18}
4922	150	5	{23}
4923	150	6	{27}
4924	150	7	{31}
4925	150	8	{37}
4926	150	9	{43,47,45}
4927	150	10	{54,50,52}
4928	150	11	{58}
4929	150	12	{63}
4930	150	13	{67}
4931	150	14	{73}
4932	150	15	{79}
4933	150	16	{83}
4934	150	17	{89}
4935	150	18	{93}
4936	150	19	{99}
4937	150	20	{103}
4938	150	21	{108}
4939	150	22	{112}
4940	150	23	{118}
4941	150	24	{123}
4942	150	25	{128}
4943	150	26	{132,136,137}
4944	150	27	{139}
4945	150	28	{145}
4946	150	29	{151,149,155}
4947	150	30	{156}
4948	150	31	{166,168}
4949	150	32	{172}
4950	150	33	{176,173}
4951	151	1	{2}
4952	151	2	{7}
4953	151	3	{11}
4954	151	4	{17}
4955	151	5	{21}
4956	151	6	{26}
4957	151	7	{32}
4958	151	8	{36}
4959	151	9	{48,41}
4960	151	10	{54,49,52}
4961	151	11	{59}
4962	151	12	{63}
4963	151	13	{68}
4964	151	14	{73}
4965	151	15	{81}
4966	151	16	{84}
4967	151	17	{87}
4968	151	18	{93}
4969	151	19	{98}
4970	151	20	{103}
4971	151	21	{109}
4972	151	22	{112}
4973	151	23	{118}
4974	151	24	{123}
4975	151	25	{129}
4976	151	26	{132,135,136}
4977	151	27	{139}
4978	151	28	{144}
4979	151	29	{148,155}
4980	151	30	{159}
4981	151	31	{166,168,162}
4982	151	32	{171}
4983	151	33	{178,181,173}
4984	152	1	{3}
4985	152	2	{7}
4986	152	3	{12}
4987	152	4	{17}
4988	152	5	{22}
4989	152	6	{27}
4990	152	7	{32}
4991	152	8	{36}
4992	152	9	{45}
4993	152	10	{51,49}
4994	152	11	{59}
4995	152	12	{63}
4996	152	13	{68}
4997	152	14	{72}
4998	152	15	{79}
4999	152	16	{83}
5000	152	17	{89}
5001	152	18	{92}
5002	152	19	{98}
5003	152	20	{103}
5004	152	21	{109}
5005	152	22	{113}
5006	152	23	{118}
5007	152	24	{123}
5008	152	25	{127}
5009	152	26	{134,137}
5010	152	27	{139}
5011	152	28	{145}
5012	152	29	{153,150,149}
5013	152	30	{160}
5014	152	31	{164}
5015	152	32	{171}
5016	152	33	{178,174,177}
5017	153	1	{2}
5018	153	2	{7}
5019	153	3	{13}
5020	153	4	{17}
5021	153	5	{22}
5022	153	6	{28}
5023	153	7	{33}
5024	153	8	{37}
5025	153	9	{42,48,46}
5026	153	10	{54,51,49}
5027	153	11	{57}
5028	153	12	{66}
5029	153	13	{68}
5030	153	14	{74}
5031	153	15	{80}
5032	153	16	{83}
5033	153	17	{88}
5034	153	18	{93}
5035	153	19	{98}
5036	153	20	{103}
5037	153	21	{109}
5038	153	22	{114}
5039	153	23	{119}
5040	153	24	{125}
5041	153	25	{128}
5042	153	26	{137}
5043	153	27	{138}
5044	153	28	{145}
5045	153	29	{148,149,155}
5046	153	30	{157}
5047	153	31	{166}
5048	153	32	{172}
5049	153	33	{181,175,173}
5050	154	1	{2}
5051	154	2	{8}
5052	154	3	{13}
5053	154	4	{16}
5054	154	5	{21}
5055	154	6	{28}
5056	154	7	{32}
5057	154	8	{37}
5058	154	9	{43,41}
5059	154	10	{50,55}
5060	154	11	{58}
5061	154	12	{63}
5062	154	13	{68}
5063	154	14	{73}
5064	154	15	{78}
5065	154	16	{83}
5066	154	17	{88}
5067	154	18	{93}
5068	154	19	{97}
5069	154	20	{106}
5070	154	21	{111}
5071	154	22	{112}
5072	154	23	{118}
5073	154	24	{123}
5074	154	25	{128}
5075	154	26	{133}
5076	154	27	{139}
5077	154	28	{144}
5078	154	29	{148,150,149}
5079	154	30	{157}
5080	154	31	{166,168,164}
5081	154	32	{171}
5082	154	33	{181,175,174}
5083	155	1	{2}
5084	155	2	{8}
5085	155	3	{12}
5086	155	4	{16}
5087	155	5	{22}
5088	155	6	{28}
5089	155	7	{32}
5090	155	8	{37}
5091	155	9	{41}
5092	155	10	{54,53,55}
5093	155	11	{58}
5094	155	12	{63}
5095	155	13	{67}
5096	155	14	{73}
5097	155	15	{78}
5098	155	16	{83}
5099	155	17	{90}
5100	155	18	{93}
5101	155	19	{98}
5102	155	20	{104}
5103	155	21	{110}
5104	155	22	{115}
5105	155	23	{118}
5106	155	24	{122}
5107	155	25	{128}
5108	155	26	{137}
5109	155	27	{139}
5110	155	28	{144}
5111	155	29	{149}
5112	155	30	{156}
5113	155	31	{167,161,162}
5114	155	32	{170}
5115	155	33	{181,177,173}
5116	156	1	{2}
5117	156	2	{7}
5118	156	3	{11}
5119	156	4	{17}
5120	156	5	{22}
5121	156	6	{27}
5122	156	7	{32}
5123	156	8	{37}
5124	156	9	{48,46,44}
5125	156	10	{53,50}
5126	156	11	{58}
5127	156	12	{63}
5128	156	13	{67}
5129	156	14	{74}
5130	156	15	{78}
5131	156	16	{83}
5132	156	17	{88}
5133	156	18	{93}
5134	156	19	{98}
5135	156	20	{103}
5136	156	21	{109}
5137	156	22	{113}
5138	156	23	{118}
5139	156	24	{123}
5140	156	25	{127}
5141	156	26	{134,137}
5142	156	27	{138}
5143	156	28	{144}
5144	156	29	{154,155}
5145	156	30	{156}
5146	156	31	{166,161,165}
5147	156	32	{171}
5148	156	33	{180}
5149	157	1	{2}
5150	157	2	{7}
5151	157	3	{14}
5152	157	4	{17}
5153	157	5	{21}
5154	157	6	{27}
5155	157	7	{33}
5156	157	8	{36}
5157	157	9	{43}
5158	157	10	{55}
5159	157	11	{57}
5160	157	12	{63}
5161	157	13	{69}
5162	157	14	{74}
5163	157	15	{78}
5164	157	16	{83}
5165	157	17	{90}
5166	157	18	{93}
5167	157	19	{101}
5168	157	20	{104}
5169	157	21	{108}
5170	157	22	{113}
5171	157	23	{121}
5172	157	24	{124}
5173	157	25	{128}
5174	157	26	{136}
5175	157	27	{138}
5176	157	28	{144}
5177	157	29	{155}
5178	157	30	{157}
5179	157	31	{163,161,162}
5180	157	32	{172}
5181	157	33	{178,181}
5182	158	1	{2}
5183	158	2	{7}
5184	158	3	{13}
5185	158	4	{17}
5186	158	5	{22}
5187	158	6	{27}
5188	158	7	{32}
5189	158	8	{37}
5190	158	9	{46,41}
5191	158	10	{51,56}
5192	158	11	{57}
5193	158	12	{64}
5194	158	13	{68}
5195	158	14	{72}
5196	158	15	{77}
5197	158	16	{83}
5198	158	17	{88}
5199	158	18	{93}
5200	158	19	{101}
5201	158	20	{103}
5202	158	21	{109}
5203	158	22	{114}
5204	158	23	{118}
5205	158	24	{123}
5206	158	25	{128}
5207	158	26	{132,137}
5208	158	27	{138}
5209	158	28	{144}
5210	158	29	{151,150,154}
5211	158	30	{156}
5212	158	31	{165}
5213	158	32	{172}
5214	158	33	{180,174,173}
5215	159	1	{2}
5216	159	2	{7}
5217	159	3	{13}
5218	159	4	{17}
5219	159	5	{22}
5220	159	6	{27}
5221	159	7	{35}
5222	159	8	{37}
5223	159	9	{48,44,43}
5224	159	10	{51,55,49}
5225	159	11	{58}
5226	159	12	{63}
5227	159	13	{68}
5228	159	14	{73}
5229	159	15	{77}
5230	159	16	{83}
5231	159	17	{89}
5232	159	18	{93}
5233	159	19	{97}
5234	159	20	{104}
5235	159	21	{109}
5236	159	22	{112}
5237	159	23	{118}
5238	159	24	{123}
5239	159	25	{127}
5240	159	26	{134,136,137}
5241	159	27	{139}
5242	159	28	{143}
5243	159	29	{150,149}
5244	159	30	{160}
5245	159	31	{168}
5246	159	32	{170}
5247	159	33	{179,174}
5248	160	1	{5}
5249	160	2	{7}
5250	160	3	{11}
5251	160	4	{17}
5252	160	5	{23}
5253	160	6	{27}
5254	160	7	{32}
5255	160	8	{37}
5256	160	9	{44,43,45}
5257	160	10	{53,51}
5258	160	11	{58}
5259	160	12	{66}
5260	160	13	{69}
5261	160	14	{73}
5262	160	15	{77}
5263	160	16	{84}
5264	160	17	{88}
5265	160	18	{95}
5266	160	19	{97}
5267	160	20	{102}
5268	160	21	{109}
5269	160	22	{113}
5270	160	23	{118}
5271	160	24	{123}
5272	160	25	{128}
5273	160	26	{135}
5274	160	27	{139}
5275	160	28	{146}
5276	160	29	{148,153,149}
5277	160	30	{160}
5278	160	31	{163,167,168}
5279	160	32	{170}
5280	160	33	{179,181,174}
5281	161	1	{2}
5282	161	2	{8}
5283	161	3	{13}
5284	161	4	{17}
5285	161	5	{22}
5286	161	6	{27}
5287	161	7	{33}
5288	161	8	{37}
5289	161	9	{45}
5290	161	10	{52}
5291	161	11	{58}
5292	161	12	{64}
5293	161	13	{68}
5294	161	14	{73}
5295	161	15	{80}
5296	161	16	{84}
5297	161	17	{89}
5298	161	18	{93}
5299	161	19	{98}
5300	161	20	{104}
5301	161	21	{109}
5302	161	22	{112}
5303	161	23	{118}
5304	161	24	{123}
5305	161	25	{129}
5306	161	26	{134,136,137}
5307	161	27	{138}
5308	161	28	{145}
5309	161	29	{153,152,155}
5310	161	30	{160}
5311	161	31	{163}
5312	161	32	{171}
5313	161	33	{180,177,173}
5314	162	1	{1}
5315	162	2	{7}
5316	162	3	{12}
5317	162	4	{17}
5318	162	5	{22}
5319	162	6	{26}
5320	162	7	{32}
5321	162	8	{36}
5322	162	9	{42,45}
5323	162	10	{54}
5324	162	11	{58}
5325	162	12	{62}
5326	162	13	{68}
5327	162	14	{73}
5328	162	15	{79}
5329	162	16	{83}
5330	162	17	{88}
5331	162	18	{96}
5332	162	19	{98}
5333	162	20	{103}
5334	162	21	{109}
5335	162	22	{113}
5336	162	23	{118}
5337	162	24	{123}
5338	162	25	{128}
5339	162	26	{135,134,137}
5340	162	27	{139}
5341	162	28	{145}
5342	162	29	{148,155}
5343	162	30	{160}
5344	162	31	{162}
5345	162	32	{172}
5346	162	33	{181,180,174}
5347	163	1	{2}
5348	163	2	{8}
5349	163	3	{12}
5350	163	4	{17}
5351	163	5	{22}
5352	163	6	{28}
5353	163	7	{31}
5354	163	8	{36}
5355	163	9	{42,47,45}
5356	163	10	{51}
5357	163	11	{57}
5358	163	12	{63}
5359	163	13	{68}
5360	163	14	{73}
5361	163	15	{77}
5362	163	16	{83}
5363	163	17	{90}
5364	163	18	{93}
5365	163	19	{97}
5366	163	20	{102}
5367	163	21	{108}
5368	163	22	{113}
5369	163	23	{118}
5370	163	24	{123}
5371	163	25	{128}
5372	163	26	{132,135,134}
5373	163	27	{142}
5374	163	28	{144}
5375	163	29	{148,153,155}
5376	163	30	{160}
5377	163	31	{161,162}
5378	163	32	{170}
5379	163	33	{176,175,173}
5380	164	1	{2}
5381	164	2	{7}
5382	164	3	{12}
5383	164	4	{17}
5384	164	5	{22}
5385	164	6	{26}
5386	164	7	{33}
5387	164	8	{37}
5388	164	9	{43,45}
5389	164	10	{55}
5390	164	11	{58}
5391	164	12	{62}
5392	164	13	{68}
5393	164	14	{73}
5394	164	15	{77}
5395	164	16	{83}
5396	164	17	{88}
5397	164	18	{93}
5398	164	19	{98}
5399	164	20	{103}
5400	164	21	{108}
5401	164	22	{114}
5402	164	23	{118}
5403	164	24	{123}
5404	164	25	{129}
5405	164	26	{137}
5406	164	27	{139}
5407	164	28	{144}
5408	164	29	{152,155}
5409	164	30	{158}
5410	164	31	{166,168}
5411	164	32	{172}
5412	164	33	{176,174,177}
5413	165	1	{2}
5414	165	2	{8}
5415	165	3	{11}
5416	165	4	{17}
5417	165	5	{22}
5418	165	6	{27}
5419	165	7	{32}
5420	165	8	{39}
5421	165	9	{47}
5422	165	10	{53,50,55}
5423	165	11	{58}
5424	165	12	{64}
5425	165	13	{70}
5426	165	14	{74}
5427	165	15	{78}
5428	165	16	{83}
5429	165	17	{87}
5430	165	18	{93}
5431	165	19	{98}
5432	165	20	{103}
5433	165	21	{109}
5434	165	22	{112}
5435	165	23	{118}
5436	165	24	{122}
5437	165	25	{127}
5438	165	26	{132}
5439	165	27	{138}
5440	165	28	{144}
5441	165	29	{151,154,155}
5442	165	30	{156}
5443	165	31	{166,161,162}
5444	165	32	{170}
5445	165	33	{177}
5446	166	1	{2}
5447	166	2	{7}
5448	166	3	{12}
5449	166	4	{19}
5450	166	5	{25}
5451	166	6	{26}
5452	166	7	{32}
5453	166	8	{37}
5454	166	9	{43,41,47}
5455	166	10	{54,50,55}
5456	166	11	{59}
5457	166	12	{64}
5458	166	13	{68}
5459	166	14	{73}
5460	166	15	{77}
5461	166	16	{82}
5462	166	17	{89}
5463	166	18	{93}
5464	166	19	{97}
5465	166	20	{102}
5466	166	21	{108}
5467	166	22	{113}
5468	166	23	{119}
5469	166	24	{123}
5470	166	25	{127}
5471	166	26	{133,132}
5472	166	27	{139}
5473	166	28	{144}
5474	166	29	{153,149,155}
5475	166	30	{157}
5476	166	31	{167,162}
5477	166	32	{172}
5478	166	33	{174,173}
5479	167	1	{3}
5480	167	2	{8}
5481	167	3	{12}
5482	167	4	{17}
5483	167	5	{22}
5484	167	6	{28}
5485	167	7	{32}
5486	167	8	{37}
5487	167	9	{42,44,43}
5488	167	10	{49}
5489	167	11	{58}
5490	167	12	{62}
5491	167	13	{67}
5492	167	14	{76}
5493	167	15	{77}
5494	167	16	{83}
5495	167	17	{88}
5496	167	18	{93}
5497	167	19	{98}
5498	167	20	{103}
5499	167	21	{109}
5500	167	22	{113}
5501	167	23	{118}
5502	167	24	{124}
5503	167	25	{128}
5504	167	26	{133,135}
5505	167	27	{140}
5506	167	28	{144}
5507	167	29	{152,155}
5508	167	30	{159}
5509	167	31	{162,169}
5510	167	32	{170}
5511	167	33	{178,176,175}
5512	168	1	{2}
5513	168	2	{7}
5514	168	3	{12}
5515	168	4	{16}
5516	168	5	{22}
5517	168	6	{26}
5518	168	7	{32}
5519	168	8	{37}
5520	168	9	{46}
5521	168	10	{54,49}
5522	168	11	{58}
5523	168	12	{63}
5524	168	13	{68}
5525	168	14	{73}
5526	168	15	{78}
5527	168	16	{83}
5528	168	17	{88}
5529	168	18	{92}
5530	168	19	{98}
5531	168	20	{103}
5532	168	21	{111}
5533	168	22	{113}
5534	168	23	{118}
5535	168	24	{124}
5536	168	25	{128}
5537	168	26	{132,137}
5538	168	27	{139}
5539	168	28	{144}
5540	168	29	{155}
5541	168	30	{158}
5542	168	31	{162}
5543	168	32	{170}
5544	168	33	{178,179}
5545	169	1	{2}
5546	169	2	{7}
5547	169	3	{12}
5548	169	4	{17}
5549	169	5	{22}
5550	169	6	{26}
5551	169	7	{32}
5552	169	8	{36}
5553	169	9	{42,41,45}
5554	169	10	{51,49,52}
5555	169	11	{58}
5556	169	12	{63}
5557	169	13	{68}
5558	169	14	{73}
5559	169	15	{79}
5560	169	16	{83}
5561	169	17	{87}
5562	169	18	{92}
5563	169	19	{98}
5564	169	20	{103}
5565	169	21	{109}
5566	169	22	{112}
5567	169	23	{120}
5568	169	24	{124}
5569	169	25	{128}
5570	169	26	{132,135,137}
5571	169	27	{139}
5572	169	28	{144}
5573	169	29	{148,149}
5574	169	30	{159}
5575	169	31	{163,165,164}
5576	169	32	{170}
5577	169	33	{178,180,173}
5578	170	1	{2}
5579	170	2	{7}
5580	170	3	{12}
5581	170	4	{16}
5582	170	5	{22}
5583	170	6	{26}
5584	170	7	{34}
5585	170	8	{37}
5586	170	9	{41,45}
5587	170	10	{50,51,56}
5588	170	11	{58}
5589	170	12	{63}
5590	170	13	{68}
5591	170	14	{73}
5592	170	15	{78}
5593	170	16	{83}
5594	170	17	{89}
5595	170	18	{94}
5596	170	19	{98}
5597	170	20	{103}
5598	170	21	{109}
5599	170	22	{114}
5600	170	23	{121}
5601	170	24	{123}
5602	170	25	{128}
5603	170	26	{133,134}
5604	170	27	{138}
5605	170	28	{145}
5606	170	29	{152,154}
5607	170	30	{160}
5608	170	31	{162,165,164}
5609	170	32	{172}
5610	170	33	{179,175}
5611	171	1	{2}
5612	171	2	{7}
5613	171	3	{12}
5614	171	4	{17}
5615	171	5	{22}
5616	171	6	{28}
5617	171	7	{33}
5618	171	8	{37}
5619	171	9	{46,43}
5620	171	10	{49}
5621	171	11	{57}
5622	171	12	{62}
5623	171	13	{68}
5624	171	14	{73}
5625	171	15	{78}
5626	171	16	{83}
5627	171	17	{88}
5628	171	18	{93}
5629	171	19	{98}
5630	171	20	{103}
5631	171	21	{108}
5632	171	22	{114}
5633	171	23	{118}
5634	171	24	{123}
5635	171	25	{128}
5636	171	26	{133,135,137}
5637	171	27	{139}
5638	171	28	{144}
5639	171	29	{154}
5640	171	30	{160}
5641	171	31	{169}
5642	171	32	{172}
5643	171	33	{178,175}
5644	172	1	{2}
5645	172	2	{7}
5646	172	3	{14}
5647	172	4	{17}
5648	172	5	{22}
5649	172	6	{26}
5650	172	7	{32}
5651	172	8	{37}
5652	172	9	{48}
5653	172	10	{55,56}
5654	172	11	{58}
5655	172	12	{62}
5656	172	13	{68}
5657	172	14	{73}
5658	172	15	{78}
5659	172	16	{84}
5660	172	17	{89}
5661	172	18	{93}
5662	172	19	{98}
5663	172	20	{102}
5664	172	21	{109}
5665	172	22	{112}
5666	172	23	{118}
5667	172	24	{123}
5668	172	25	{127}
5669	172	26	{135}
5670	172	27	{140}
5671	172	28	{144}
5672	172	29	{149,155}
5673	172	30	{159}
5674	172	31	{166,169}
5675	172	32	{172}
5676	172	33	{179,175,177}
5677	173	1	{2}
5678	173	2	{7}
5679	173	3	{13}
5680	173	4	{17}
5681	173	5	{22}
5682	173	6	{27}
5683	173	7	{32}
5684	173	8	{37}
5685	173	9	{42,44,41}
5686	173	10	{55}
5687	173	11	{58}
5688	173	12	{63}
5689	173	13	{68}
5690	173	14	{73}
5691	173	15	{81}
5692	173	16	{83}
5693	173	17	{88}
5694	173	18	{93}
5695	173	19	{99}
5696	173	20	{103}
5697	173	21	{109}
5698	173	22	{113}
5699	173	23	{117}
5700	173	24	{123}
5701	173	25	{129}
5702	173	26	{136}
5703	173	27	{139}
5704	173	28	{144}
5705	173	29	{148,149,154}
5706	173	30	{158}
5707	173	31	{161}
5708	173	32	{170}
5709	173	33	{180}
5710	174	1	{2}
5711	174	2	{8}
5712	174	3	{11}
5713	174	4	{17}
5714	174	5	{21}
5715	174	6	{28}
5716	174	7	{32}
5717	174	8	{37}
5718	174	9	{47}
5719	174	10	{53,49}
5720	174	11	{58}
5721	174	12	{63}
5722	174	13	{69}
5723	174	14	{73}
5724	174	15	{78}
5725	174	16	{85}
5726	174	17	{88}
5727	174	18	{93}
5728	174	19	{97}
5729	174	20	{102}
5730	174	21	{109}
5731	174	22	{113}
5732	174	23	{118}
5733	174	24	{124}
5734	174	25	{127}
5735	174	26	{132,134,137}
5736	174	27	{139}
5737	174	28	{144}
5738	174	29	{153,154,155}
5739	174	30	{160}
5740	174	31	{166}
5741	174	32	{172}
5742	174	33	{179,176,180}
5743	175	1	{2}
5744	175	2	{7}
5745	175	3	{12}
5746	175	4	{17}
5747	175	5	{22}
5748	175	6	{26}
5749	175	7	{32}
5750	175	8	{38}
5751	175	9	{41}
5752	175	10	{51}
5753	175	11	{57}
5754	175	12	{63}
5755	175	13	{69}
5756	175	14	{74}
5757	175	15	{79}
5758	175	16	{83}
5759	175	17	{89}
5760	175	18	{93}
5761	175	19	{99}
5762	175	20	{104}
5763	175	21	{109}
5764	175	22	{113}
5765	175	23	{118}
5766	175	24	{123}
5767	175	25	{127}
5768	175	26	{137}
5769	175	27	{138}
5770	175	28	{144}
5771	175	29	{155}
5772	175	30	{159}
5773	175	31	{167,168,162}
5774	175	32	{171}
5775	175	33	{175}
5776	176	1	{2}
5777	176	2	{7}
5778	176	3	{12}
5779	176	4	{17}
5780	176	5	{22}
5781	176	6	{27}
5782	176	7	{32}
5783	176	8	{36}
5784	176	9	{44}
5785	176	10	{56,49}
5786	176	11	{58}
5787	176	12	{63}
5788	176	13	{68}
5789	176	14	{76}
5790	176	15	{77}
5791	176	16	{83}
5792	176	17	{88}
5793	176	18	{93}
5794	176	19	{98}
5795	176	20	{103}
5796	176	21	{109}
5797	176	22	{113}
5798	176	23	{118}
5799	176	24	{123}
5800	176	25	{128}
5801	176	26	{133,136,137}
5802	176	27	{139}
5803	176	28	{146}
5804	176	29	{148,152,155}
5805	176	30	{160}
5806	176	31	{163}
5807	176	32	{170}
5808	176	33	{180}
5809	177	1	{2}
5810	177	2	{7}
5811	177	3	{13}
5812	177	4	{16}
5813	177	5	{22}
5814	177	6	{27}
5815	177	7	{32}
5816	177	8	{37}
5817	177	9	{42,48,47}
5818	177	10	{51,49}
5819	177	11	{59}
5820	177	12	{64}
5821	177	13	{69}
5822	177	14	{73}
5823	177	15	{80}
5824	177	16	{83}
5825	177	17	{89}
5826	177	18	{93}
5827	177	19	{98}
5828	177	20	{103}
5829	177	21	{108}
5830	177	22	{113}
5831	177	23	{118}
5832	177	24	{124}
5833	177	25	{128}
5834	177	26	{132,135}
5835	177	27	{141}
5836	177	28	{144}
5837	177	29	{151,150}
5838	177	30	{160}
5839	177	31	{167,166}
5840	177	32	{171}
5841	177	33	{178,176,174}
5842	178	1	{1}
5843	178	2	{8}
5844	178	3	{12}
5845	178	4	{18}
5846	178	5	{25}
5847	178	6	{28}
5848	178	7	{32}
5849	178	8	{37}
5850	178	9	{41,45}
5851	178	10	{50,55}
5852	178	11	{58}
5853	178	12	{62}
5854	178	13	{68}
5855	178	14	{73}
5856	178	15	{78}
5857	178	16	{84}
5858	178	17	{88}
5859	178	18	{92}
5860	178	19	{99}
5861	178	20	{103}
5862	178	21	{109}
5863	178	22	{113}
5864	178	23	{119}
5865	178	24	{124}
5866	178	25	{129}
5867	178	26	{133}
5868	178	27	{139}
5869	178	28	{146}
5870	178	29	{154}
5871	178	30	{157}
5872	178	31	{162}
5873	178	32	{172}
5874	178	33	{179,173}
5875	179	1	{2}
5876	179	2	{6}
5877	179	3	{12}
5878	179	4	{17}
5879	179	5	{22}
5880	179	6	{26}
5881	179	7	{33}
5882	179	8	{37}
5883	179	9	{46,44,45}
5884	179	10	{49,52}
5885	179	11	{59}
5886	179	12	{64}
5887	179	13	{67}
5888	179	14	{72}
5889	179	15	{79}
5890	179	16	{84}
5891	179	17	{88}
5892	179	18	{93}
5893	179	19	{98}
5894	179	20	{103}
5895	179	21	{110}
5896	179	22	{114}
5897	179	23	{118}
5898	179	24	{122}
5899	179	25	{128}
5900	179	26	{133,132,136}
5901	179	27	{140}
5902	179	28	{144}
5903	179	29	{151,149,155}
5904	179	30	{160}
5905	179	31	{167,168,162}
5906	179	32	{172}
5907	179	33	{174}
5908	180	1	{2}
5909	180	2	{7}
5910	180	3	{13}
5911	180	4	{17}
5912	180	5	{22}
5913	180	6	{27}
5914	180	7	{33}
5915	180	8	{37}
5916	180	9	{42,41}
5917	180	10	{56}
5918	180	11	{58}
5919	180	12	{65}
5920	180	13	{69}
5921	180	14	{72}
5922	180	15	{79}
5923	180	16	{83}
5924	180	17	{89}
5925	180	18	{95}
5926	180	19	{98}
5927	180	20	{103}
5928	180	21	{110}
5929	180	22	{113}
5930	180	23	{117}
5931	180	24	{124}
5932	180	25	{129}
5933	180	26	{132}
5934	180	27	{139}
5935	180	28	{147}
5936	180	29	{150}
5937	180	30	{159}
5938	180	31	{164}
5939	180	32	{170}
5940	180	33	{178,174}
5941	181	1	{2}
5942	181	2	{7}
5943	181	3	{12}
5944	181	4	{17}
5945	181	5	{21}
5946	181	6	{26}
5947	181	7	{32}
5948	181	8	{38}
5949	181	9	{48,45}
5950	181	10	{52}
5951	181	11	{61}
5952	181	12	{63}
5953	181	13	{68}
5954	181	14	{73}
5955	181	15	{77}
5956	181	16	{83}
5957	181	17	{88}
5958	181	18	{93}
5959	181	19	{98}
5960	181	20	{102}
5961	181	21	{109}
5962	181	22	{113}
5963	181	23	{118}
5964	181	24	{123}
5965	181	25	{128}
5966	181	26	{133,132,134}
5967	181	27	{139}
5968	181	28	{145}
5969	181	29	{154}
5970	181	30	{157}
5971	181	31	{164}
5972	181	32	{170}
5973	181	33	{181,176}
5974	182	1	{2}
5975	182	2	{7}
5976	182	3	{12}
5977	182	4	{16}
5978	182	5	{25}
5979	182	6	{28}
5980	182	7	{32}
5981	182	8	{37}
5982	182	9	{47}
5983	182	10	{54}
5984	182	11	{58}
5985	182	12	{64}
5986	182	13	{68}
5987	182	14	{73}
5988	182	15	{79}
5989	182	16	{83}
5990	182	17	{89}
5991	182	18	{93}
5992	182	19	{98}
5993	182	20	{103}
5994	182	21	{111}
5995	182	22	{112}
5996	182	23	{118}
5997	182	24	{123}
5998	182	25	{127}
5999	182	26	{134,137}
6000	182	27	{139}
6001	182	28	{144}
6002	182	29	{152,149}
6003	182	30	{159}
6004	182	31	{167,161,165}
6005	182	32	{170}
6006	182	33	{181}
6007	183	1	{4}
6008	183	2	{7}
6009	183	3	{11}
6010	183	4	{18}
6011	183	5	{22}
6012	183	6	{27}
6013	183	7	{33}
6014	183	8	{36}
6015	183	9	{42,45}
6016	183	10	{52}
6017	183	11	{58}
6018	183	12	{63}
6019	183	13	{68}
6020	183	14	{73}
6021	183	15	{79}
6022	183	16	{83}
6023	183	17	{89}
6024	183	18	{94}
6025	183	19	{98}
6026	183	20	{103}
6027	183	21	{109}
6028	183	22	{113}
6029	183	23	{119}
6030	183	24	{124}
6031	183	25	{128}
6032	183	26	{133,132}
6033	183	27	{139}
6034	183	28	{144}
6035	183	29	{151,153}
6036	183	30	{158}
6037	183	31	{162}
6038	183	32	{170}
6039	183	33	{174,177}
6040	184	1	{2}
6041	184	2	{6}
6042	184	3	{11}
6043	184	4	{18}
6044	184	5	{21}
6045	184	6	{27}
6046	184	7	{32}
6047	184	8	{38}
6048	184	9	{46,44}
6049	184	10	{50,51}
6050	184	11	{58}
6051	184	12	{63}
6052	184	13	{69}
6053	184	14	{74}
6054	184	15	{78}
6055	184	16	{85}
6056	184	17	{89}
6057	184	18	{93}
6058	184	19	{98}
6059	184	20	{103}
6060	184	21	{108}
6061	184	22	{113}
6062	184	23	{118}
6063	184	24	{123}
6064	184	25	{128}
6065	184	26	{132}
6066	184	27	{139}
6067	184	28	{144}
6068	184	29	{151,150}
6069	184	30	{160}
6070	184	31	{168,161,164}
6071	184	32	{171}
6072	184	33	{177}
6073	185	1	{3}
6074	185	2	{8}
6075	185	3	{12}
6076	185	4	{17}
6077	185	5	{23}
6078	185	6	{27}
6079	185	7	{31}
6080	185	8	{37}
6081	185	9	{42,41}
6082	185	10	{51,55,49}
6083	185	11	{58}
6084	185	12	{62}
6085	185	13	{67}
6086	185	14	{72}
6087	185	15	{78}
6088	185	16	{82}
6089	185	17	{88}
6090	185	18	{93}
6091	185	19	{98}
6092	185	20	{103}
6093	185	21	{109}
6094	185	22	{113}
6095	185	23	{117}
6096	185	24	{123}
6097	185	25	{127}
6098	185	26	{137}
6099	185	27	{139}
6100	185	28	{144}
6101	185	29	{153}
6102	185	30	{160}
6103	185	31	{163}
6104	185	32	{170}
6105	185	33	{174}
6106	186	1	{2}
6107	186	2	{7}
6108	186	3	{12}
6109	186	4	{17}
6110	186	5	{22}
6111	186	6	{27}
6112	186	7	{32}
6113	186	8	{37}
6114	186	9	{41}
6115	186	10	{51,56}
6116	186	11	{58}
6117	186	12	{63}
6118	186	13	{68}
6119	186	14	{73}
6120	186	15	{78}
6121	186	16	{83}
6122	186	17	{88}
6123	186	18	{93}
6124	186	19	{98}
6125	186	20	{103}
6126	186	21	{109}
6127	186	22	{114}
6128	186	23	{118}
6129	186	24	{124}
6130	186	25	{128}
6131	186	26	{137}
6132	186	27	{139}
6133	186	28	{144}
6134	186	29	{154}
6135	186	30	{156}
6136	186	31	{167,166,165}
6137	186	32	{170}
6138	186	33	{181}
6139	187	1	{2}
6140	187	2	{8}
6141	187	3	{12}
6142	187	4	{17}
6143	187	5	{22}
6144	187	6	{27}
6145	187	7	{32}
6146	187	8	{37}
6147	187	9	{46,44}
6148	187	10	{50,51,49}
6149	187	11	{59}
6150	187	12	{63}
6151	187	13	{68}
6152	187	14	{73}
6153	187	15	{78}
6154	187	16	{83}
6155	187	17	{87}
6156	187	18	{93}
6157	187	19	{97}
6158	187	20	{103}
6159	187	21	{109}
6160	187	22	{113}
6161	187	23	{118}
6162	187	24	{126}
6163	187	25	{128}
6164	187	26	{135}
6165	187	27	{138}
6166	187	28	{144}
6167	187	29	{150}
6168	187	30	{159}
6169	187	31	{168,169}
6170	187	32	{170}
6171	187	33	{176}
6172	188	1	{2}
6173	188	2	{8}
6174	188	3	{11}
6175	188	4	{17}
6176	188	5	{24}
6177	188	6	{27}
6178	188	7	{32}
6179	188	8	{37}
6180	188	9	{46}
6181	188	10	{50,56,52}
6182	188	11	{57}
6183	188	12	{64}
6184	188	13	{69}
6185	188	14	{72}
6186	188	15	{78}
6187	188	16	{82}
6188	188	17	{88}
6189	188	18	{93}
6190	188	19	{98}
6191	188	20	{103}
6192	188	21	{111}
6193	188	22	{112}
6194	188	23	{117}
6195	188	24	{124}
6196	188	25	{129}
6197	188	26	{135,134}
6198	188	27	{140}
6199	188	28	{143}
6200	188	29	{148,153}
6201	188	30	{157}
6202	188	31	{167,164}
6203	188	32	{172}
6204	188	33	{175}
6205	189	1	{1}
6206	189	2	{6}
6207	189	3	{12}
6208	189	4	{17}
6209	189	5	{23}
6210	189	6	{27}
6211	189	7	{32}
6212	189	8	{38}
6213	189	9	{42}
6214	189	10	{51,55,56}
6215	189	11	{58}
6216	189	12	{62}
6217	189	13	{68}
6218	189	14	{72}
6219	189	15	{77}
6220	189	16	{83}
6221	189	17	{91}
6222	189	18	{96}
6223	189	19	{98}
6224	189	20	{103}
6225	189	21	{109}
6226	189	22	{113}
6227	189	23	{117}
6228	189	24	{126}
6229	189	25	{128}
6230	189	26	{132,136}
6231	189	27	{139}
6232	189	28	{146}
6233	189	29	{151,153,149}
6234	189	30	{158}
6235	189	31	{163,161}
6236	189	32	{172}
6237	189	33	{174}
6238	190	1	{2}
6239	190	2	{6}
6240	190	3	{12}
6241	190	4	{17}
6242	190	5	{25}
6243	190	6	{28}
6244	190	7	{32}
6245	190	8	{37}
6246	190	9	{45}
6247	190	10	{50,56}
6248	190	11	{58}
6249	190	12	{63}
6250	190	13	{68}
6251	190	14	{74}
6252	190	15	{78}
6253	190	16	{83}
6254	190	17	{88}
6255	190	18	{93}
6256	190	19	{98}
6257	190	20	{102}
6258	190	21	{109}
6259	190	22	{113}
6260	190	23	{119}
6261	190	24	{123}
6262	190	25	{128}
6263	190	26	{134}
6264	190	27	{139}
6265	190	28	{145}
6266	190	29	{153,154}
6267	190	30	{159}
6268	190	31	{162}
6269	190	32	{171}
6270	190	33	{175,173}
6271	191	1	{3}
6272	191	2	{8}
6273	191	3	{13}
6274	191	4	{16}
6275	191	5	{21}
6276	191	6	{27}
6277	191	7	{33}
6278	191	8	{37}
6279	191	9	{48,43,47}
6280	191	10	{52}
6281	191	11	{58}
6282	191	12	{62}
6283	191	13	{67}
6284	191	14	{74}
6285	191	15	{78}
6286	191	16	{83}
6287	191	17	{88}
6288	191	18	{92}
6289	191	19	{98}
6290	191	20	{103}
6291	191	21	{109}
6292	191	22	{113}
6293	191	23	{120}
6294	191	24	{123}
6295	191	25	{128}
6296	191	26	{135}
6297	191	27	{139}
6298	191	28	{145}
6299	191	29	{151}
6300	191	30	{159}
6301	191	31	{168}
6302	191	32	{170}
6303	191	33	{180}
6304	192	1	{1}
6305	192	2	{7}
6306	192	3	{12}
6307	192	4	{17}
6308	192	5	{22}
6309	192	6	{27}
6310	192	7	{31}
6311	192	8	{37}
6312	192	9	{46,43,41}
6313	192	10	{50,56}
6314	192	11	{58}
6315	192	12	{63}
6316	192	13	{69}
6317	192	14	{73}
6318	192	15	{77}
6319	192	16	{83}
6320	192	17	{88}
6321	192	18	{95}
6322	192	19	{99}
6323	192	20	{103}
6324	192	21	{110}
6325	192	22	{113}
6326	192	23	{117}
6327	192	24	{124}
6328	192	25	{127}
6329	192	26	{132,134,137}
6330	192	27	{139}
6331	192	28	{144}
6332	192	29	{151,148,153}
6333	192	30	{160}
6334	192	31	{166,161,164}
6335	192	32	{171}
6336	192	33	{181,176,177}
6337	193	1	{4}
6338	193	2	{8}
6339	193	3	{12}
6340	193	4	{16}
6341	193	5	{22}
6342	193	6	{27}
6343	193	7	{32}
6344	193	8	{38}
6345	193	9	{47}
6346	193	10	{56,49}
6347	193	11	{57}
6348	193	12	{63}
6349	193	13	{68}
6350	193	14	{73}
6351	193	15	{79}
6352	193	16	{83}
6353	193	17	{88}
6354	193	18	{92}
6355	193	19	{98}
6356	193	20	{103}
6357	193	21	{108}
6358	193	22	{114}
6359	193	23	{118}
6360	193	24	{123}
6361	193	25	{128}
6362	193	26	{136}
6363	193	27	{139}
6364	193	28	{145}
6365	193	29	{153,150,149}
6366	193	30	{159}
6367	193	31	{168,161,165}
6368	193	32	{172}
6369	193	33	{176,175}
6370	194	1	{2}
6371	194	2	{7}
6372	194	3	{12}
6373	194	4	{17}
6374	194	5	{21}
6375	194	6	{27}
6376	194	7	{33}
6377	194	8	{38}
6378	194	9	{42,44}
6379	194	10	{54,53,51}
6380	194	11	{58}
6381	194	12	{64}
6382	194	13	{67}
6383	194	14	{73}
6384	194	15	{78}
6385	194	16	{83}
6386	194	17	{88}
6387	194	18	{93}
6388	194	19	{97}
6389	194	20	{103}
6390	194	21	{108}
6391	194	22	{113}
6392	194	23	{118}
6393	194	24	{124}
6394	194	25	{128}
6395	194	26	{133,136,137}
6396	194	27	{139}
6397	194	28	{143}
6398	194	29	{151,152,154}
6399	194	30	{157}
6400	194	31	{164}
6401	194	32	{170}
6402	194	33	{181,180,177}
6403	195	1	{2}
6404	195	2	{7}
6405	195	3	{13}
6406	195	4	{17}
6407	195	5	{21}
6408	195	6	{26}
6409	195	7	{32}
6410	195	8	{36}
6411	195	9	{44,45}
6412	195	10	{54,53,56}
6413	195	11	{57}
6414	195	12	{63}
6415	195	13	{69}
6416	195	14	{73}
6417	195	15	{78}
6418	195	16	{83}
6419	195	17	{88}
6420	195	18	{93}
6421	195	19	{97}
6422	195	20	{103}
6423	195	21	{109}
6424	195	22	{113}
6425	195	23	{118}
6426	195	24	{123}
6427	195	25	{131}
6428	195	26	{133,134}
6429	195	27	{139}
6430	195	28	{144}
6431	195	29	{153,150}
6432	195	30	{158}
6433	195	31	{168,161,169}
6434	195	32	{172}
6435	195	33	{180,174,173}
6436	196	1	{3}
6437	196	2	{7}
6438	196	3	{12}
6439	196	4	{17}
6440	196	5	{22}
6441	196	6	{27}
6442	196	7	{31}
6443	196	8	{37}
6444	196	9	{48,46}
6445	196	10	{50}
6446	196	11	{57}
6447	196	12	{63}
6448	196	13	{67}
6449	196	14	{73}
6450	196	15	{78}
6451	196	16	{83}
6452	196	17	{89}
6453	196	18	{93}
6454	196	19	{98}
6455	196	20	{103}
6456	196	21	{109}
6457	196	22	{113}
6458	196	23	{118}
6459	196	24	{123}
6460	196	25	{127}
6461	196	26	{132,134,137}
6462	196	27	{138}
6463	196	28	{143}
6464	196	29	{148,153,155}
6465	196	30	{158}
6466	196	31	{163}
6467	196	32	{172}
6468	196	33	{181}
6469	197	1	{2}
6470	197	2	{7}
6471	197	3	{12}
6472	197	4	{17}
6473	197	5	{21}
6474	197	6	{26}
6475	197	7	{33}
6476	197	8	{37}
6477	197	9	{46,44,45}
6478	197	10	{56,49}
6479	197	11	{58}
6480	197	12	{64}
6481	197	13	{69}
6482	197	14	{74}
6483	197	15	{79}
6484	197	16	{82}
6485	197	17	{87}
6486	197	18	{92}
6487	197	19	{98}
6488	197	20	{104}
6489	197	21	{109}
6490	197	22	{113}
6491	197	23	{119}
6492	197	24	{123}
6493	197	25	{128}
6494	197	26	{133,135}
6495	197	27	{139}
6496	197	28	{143}
6497	197	29	{149}
6498	197	30	{157}
6499	197	31	{167,162}
6500	197	32	{172}
6501	197	33	{175}
6502	198	1	{2}
6503	198	2	{6}
6504	198	3	{13}
6505	198	4	{17}
6506	198	5	{23}
6507	198	6	{29}
6508	198	7	{32}
6509	198	8	{37}
6510	198	9	{47}
6511	198	10	{51}
6512	198	11	{59}
6513	198	12	{63}
6514	198	13	{68}
6515	198	14	{76}
6516	198	15	{78}
6517	198	16	{83}
6518	198	17	{88}
6519	198	18	{94}
6520	198	19	{98}
6521	198	20	{104}
6522	198	21	{109}
6523	198	22	{113}
6524	198	23	{117}
6525	198	24	{123}
6526	198	25	{127}
6527	198	26	{135,136}
6528	198	27	{139}
6529	198	28	{144}
6530	198	29	{153,155}
6531	198	30	{158}
6532	198	31	{168}
6533	198	32	{171}
6534	198	33	{178}
6535	199	1	{5}
6536	199	2	{6}
6537	199	3	{13}
6538	199	4	{17}
6539	199	5	{23}
6540	199	6	{27}
6541	199	7	{32}
6542	199	8	{37}
6543	199	9	{42,43}
6544	199	10	{53,51,56}
6545	199	11	{58}
6546	199	12	{63}
6547	199	13	{68}
6548	199	14	{74}
6549	199	15	{78}
6550	199	16	{83}
6551	199	17	{89}
6552	199	18	{93}
6553	199	19	{99}
6554	199	20	{103}
6555	199	21	{110}
6556	199	22	{112}
6557	199	23	{119}
6558	199	24	{123}
6559	199	25	{128}
6560	199	26	{135}
6561	199	27	{141}
6562	199	28	{146}
6563	199	29	{151}
6564	199	30	{157}
6565	199	31	{167,166}
6566	199	32	{172}
6567	199	33	{174,177,173}
6568	200	1	{2}
6569	200	2	{7}
6570	200	3	{12}
6571	200	4	{17}
6572	200	5	{23}
6573	200	6	{26}
6574	200	7	{32}
6575	200	8	{37}
6576	200	9	{44,41}
6577	200	10	{53}
6578	200	11	{58}
6579	200	12	{66}
6580	200	13	{68}
6581	200	14	{73}
6582	200	15	{79}
6583	200	16	{83}
6584	200	17	{88}
6585	200	18	{93}
6586	200	19	{98}
6587	200	20	{102}
6588	200	21	{109}
6589	200	22	{112}
6590	200	23	{119}
6591	200	24	{123}
6592	200	25	{128}
6593	200	26	{133,136}
6594	200	27	{139}
6595	200	28	{144}
6596	200	29	{152,155}
6597	200	30	{156}
6598	200	31	{163,161}
6599	200	32	{170}
6600	200	33	{175,174}
6601	201	1	{5}
6602	201	2	{7}
6603	201	3	{11}
6604	201	4	{17}
6605	201	5	{23}
6606	201	6	{27}
6607	201	7	{32}
6608	201	8	{37}
6609	201	9	{42,48,44}
6610	201	10	{52}
6611	201	11	{58}
6612	201	12	{64}
6613	201	13	{68}
6614	201	14	{73}
6615	201	15	{78}
6616	201	16	{82}
6617	201	17	{88}
6618	201	18	{93}
6619	201	19	{97}
6620	201	20	{103}
6621	201	21	{108}
6622	201	22	{116}
6623	201	23	{118}
6624	201	24	{123}
6625	201	25	{128}
6626	201	26	{133}
6627	201	27	{139}
6628	201	28	{144}
6629	201	29	{152}
6630	201	30	{156}
6631	201	31	{166,161}
6632	201	32	{171}
6633	201	33	{175,173}
6634	202	1	{2}
6635	202	2	{9}
6636	202	3	{12}
6637	202	4	{17}
6638	202	5	{22}
6639	202	6	{28}
6640	202	7	{33}
6641	202	8	{36}
6642	202	9	{42,48,45}
6643	202	10	{56}
6644	202	11	{57}
6645	202	12	{63}
6646	202	13	{71}
6647	202	14	{73}
6648	202	15	{79}
6649	202	16	{84}
6650	202	17	{88}
6651	202	18	{93}
6652	202	19	{99}
6653	202	20	{102}
6654	202	21	{108}
6655	202	22	{113}
6656	202	23	{117}
6657	202	24	{123}
6658	202	25	{128}
6659	202	26	{132,137}
6660	202	27	{140}
6661	202	28	{147}
6662	202	29	{150,155}
6663	202	30	{160}
6664	202	31	{166,169,164}
6665	202	32	{170}
6666	202	33	{175,177,173}
6667	203	1	{3}
6668	203	2	{6}
6669	203	3	{12}
6670	203	4	{18}
6671	203	5	{23}
6672	203	6	{27}
6673	203	7	{32}
6674	203	8	{37}
6675	203	9	{42,41,45}
6676	203	10	{53,51,56}
6677	203	11	{58}
6678	203	12	{63}
6679	203	13	{67}
6680	203	14	{73}
6681	203	15	{78}
6682	203	16	{83}
6683	203	17	{87}
6684	203	18	{93}
6685	203	19	{98}
6686	203	20	{103}
6687	203	21	{108}
6688	203	22	{113}
6689	203	23	{118}
6690	203	24	{123}
6691	203	25	{128}
6692	203	26	{135,134,136}
6693	203	27	{140}
6694	203	28	{144}
6695	203	29	{153}
6696	203	30	{160}
6697	203	31	{167,168,164}
6698	203	32	{171}
6699	203	33	{173}
6700	204	1	{2}
6701	204	2	{6}
6702	204	3	{12}
6703	204	4	{20}
6704	204	5	{23}
6705	204	6	{28}
6706	204	7	{32}
6707	204	8	{36}
6708	204	9	{44,43,47}
6709	204	10	{51,56,52}
6710	204	11	{57}
6711	204	12	{63}
6712	204	13	{69}
6713	204	14	{73}
6714	204	15	{77}
6715	204	16	{82}
6716	204	17	{89}
6717	204	18	{95}
6718	204	19	{99}
6719	204	20	{103}
6720	204	21	{109}
6721	204	22	{114}
6722	204	23	{118}
6723	204	24	{124}
6724	204	25	{128}
6725	204	26	{132,137}
6726	204	27	{140}
6727	204	28	{143}
6728	204	29	{152,154}
6729	204	30	{156}
6730	204	31	{161}
6731	204	32	{172}
6732	204	33	{178,176,177}
6733	205	1	{2}
6734	205	2	{7}
6735	205	3	{12}
6736	205	4	{18}
6737	205	5	{23}
6738	205	6	{27}
6739	205	7	{31}
6740	205	8	{37}
6741	205	9	{46}
6742	205	10	{54,53,49}
6743	205	11	{58}
6744	205	12	{64}
6745	205	13	{68}
6746	205	14	{72}
6747	205	15	{78}
6748	205	16	{84}
6749	205	17	{88}
6750	205	18	{93}
6751	205	19	{98}
6752	205	20	{106}
6753	205	21	{110}
6754	205	22	{113}
6755	205	23	{118}
6756	205	24	{124}
6757	205	25	{128}
6758	205	26	{135,136,137}
6759	205	27	{140}
6760	205	28	{144}
6761	205	29	{148,153,155}
6762	205	30	{159}
6763	205	31	{162}
6764	205	32	{171}
6765	205	33	{178,179,173}
6766	206	1	{2}
6767	206	2	{7}
6768	206	3	{11}
6769	206	4	{17}
6770	206	5	{21}
6771	206	6	{27}
6772	206	7	{33}
6773	206	8	{37}
6774	206	9	{48,46}
6775	206	10	{50}
6776	206	11	{57}
6777	206	12	{62}
6778	206	13	{68}
6779	206	14	{74}
6780	206	15	{81}
6781	206	16	{83}
6782	206	17	{89}
6783	206	18	{94}
6784	206	19	{97}
6785	206	20	{102}
6786	206	21	{110}
6787	206	22	{113}
6788	206	23	{118}
6789	206	24	{124}
6790	206	25	{127}
6791	206	26	{133,136}
6792	206	27	{138}
6793	206	28	{144}
6794	206	29	{151,148,155}
6795	206	30	{160}
6796	206	31	{166,168,165}
6797	206	32	{170}
6798	206	33	{175,174,173}
6799	207	1	{2}
6800	207	2	{7}
6801	207	3	{12}
6802	207	4	{18}
6803	207	5	{22}
6804	207	6	{27}
6805	207	7	{32}
6806	207	8	{37}
6807	207	9	{42,44}
6808	207	10	{51,49}
6809	207	11	{57}
6810	207	12	{63}
6811	207	13	{69}
6812	207	14	{73}
6813	207	15	{78}
6814	207	16	{83}
6815	207	17	{88}
6816	207	18	{94}
6817	207	19	{97}
6818	207	20	{103}
6819	207	21	{109}
6820	207	22	{112}
6821	207	23	{118}
6822	207	24	{123}
6823	207	25	{129}
6824	207	26	{133,132,136}
6825	207	27	{138}
6826	207	28	{144}
6827	207	29	{151,154,155}
6828	207	30	{159}
6829	207	31	{165}
6830	207	32	{172}
6831	207	33	{181,176,174}
6832	208	1	{2}
6833	208	2	{7}
6834	208	3	{13}
6835	208	4	{17}
6836	208	5	{23}
6837	208	6	{28}
6838	208	7	{32}
6839	208	8	{36}
6840	208	9	{42,44}
6841	208	10	{55}
6842	208	11	{57}
6843	208	12	{63}
6844	208	13	{68}
6845	208	14	{74}
6846	208	15	{78}
6847	208	16	{83}
6848	208	17	{87}
6849	208	18	{93}
6850	208	19	{98}
6851	208	20	{103}
6852	208	21	{109}
6853	208	22	{114}
6854	208	23	{117}
6855	208	24	{124}
6856	208	25	{128}
6857	208	26	{133,135,137}
6858	208	27	{139}
6859	208	28	{144}
6860	208	29	{154}
6861	208	30	{158}
6862	208	31	{168}
6863	208	32	{172}
6864	208	33	{173}
6865	209	1	{2}
6866	209	2	{7}
6867	209	3	{12}
6868	209	4	{17}
6869	209	5	{22}
6870	209	6	{28}
6871	209	7	{31}
6872	209	8	{37}
6873	209	9	{43}
6874	209	10	{50,49}
6875	209	11	{58}
6876	209	12	{63}
6877	209	13	{68}
6878	209	14	{73}
6879	209	15	{78}
6880	209	16	{83}
6881	209	17	{87}
6882	209	18	{93}
6883	209	19	{98}
6884	209	20	{103}
6885	209	21	{110}
6886	209	22	{113}
6887	209	23	{118}
6888	209	24	{123}
6889	209	25	{129}
6890	209	26	{133,135,134}
6891	209	27	{139}
6892	209	28	{144}
6893	209	29	{154,155}
6894	209	30	{157}
6895	209	31	{167,166,162}
6896	209	32	{172}
6897	209	33	{180,175}
6898	210	1	{2}
6899	210	2	{7}
6900	210	3	{12}
6901	210	4	{17}
6902	210	5	{23}
6903	210	6	{27}
6904	210	7	{32}
6905	210	8	{37}
6906	210	9	{48,44}
6907	210	10	{54,51}
6908	210	11	{58}
6909	210	12	{62}
6910	210	13	{68}
6911	210	14	{73}
6912	210	15	{78}
6913	210	16	{82}
6914	210	17	{88}
6915	210	18	{92}
6916	210	19	{98}
6917	210	20	{106}
6918	210	21	{108}
6919	210	22	{115}
6920	210	23	{118}
6921	210	24	{122}
6922	210	25	{128}
6923	210	26	{134,136}
6924	210	27	{139}
6925	210	28	{145}
6926	210	29	{148}
6927	210	30	{156}
6928	210	31	{167,168,165}
6929	210	32	{171}
6930	210	33	{180}
6931	211	1	{2}
6932	211	2	{7}
6933	211	3	{13}
6934	211	4	{17}
6935	211	5	{23}
6936	211	6	{26}
6937	211	7	{32}
6938	211	8	{37}
6939	211	9	{44,47}
6940	211	10	{53,52}
6941	211	11	{58}
6942	211	12	{64}
6943	211	13	{67}
6944	211	14	{73}
6945	211	15	{78}
6946	211	16	{85}
6947	211	17	{88}
6948	211	18	{93}
6949	211	19	{98}
6950	211	20	{104}
6951	211	21	{110}
6952	211	22	{115}
6953	211	23	{118}
6954	211	24	{124}
6955	211	25	{128}
6956	211	26	{132,134,137}
6957	211	27	{139}
6958	211	28	{144}
6959	211	29	{152,150}
6960	211	30	{160}
6961	211	31	{167,165,164}
6962	211	32	{171}
6963	211	33	{180}
6964	212	1	{3}
6965	212	2	{7}
6966	212	3	{13}
6967	212	4	{17}
6968	212	5	{22}
6969	212	6	{27}
6970	212	7	{32}
6971	212	8	{37}
6972	212	9	{44,47}
6973	212	10	{49}
6974	212	11	{58}
6975	212	12	{63}
6976	212	13	{68}
6977	212	14	{75}
6978	212	15	{78}
6979	212	16	{83}
6980	212	17	{87}
6981	212	18	{93}
6982	212	19	{97}
6983	212	20	{103}
6984	212	21	{109}
6985	212	22	{116}
6986	212	23	{119}
6987	212	24	{123}
6988	212	25	{128}
6989	212	26	{135}
6990	212	27	{140}
6991	212	28	{144}
6992	212	29	{149}
6993	212	30	{156}
6994	212	31	{163,165,164}
6995	212	32	{172}
6996	212	33	{178}
6997	213	1	{2}
6998	213	2	{9}
6999	213	3	{12}
7000	213	4	{17}
7001	213	5	{22}
7002	213	6	{27}
7003	213	7	{32}
7004	213	8	{37}
7005	213	9	{48,44,41}
7006	213	10	{54,56,52}
7007	213	11	{57}
7008	213	12	{63}
7009	213	13	{69}
7010	213	14	{73}
7011	213	15	{78}
7012	213	16	{84}
7013	213	17	{89}
7014	213	18	{93}
7015	213	19	{97}
7016	213	20	{103}
7017	213	21	{108}
7018	213	22	{113}
7019	213	23	{119}
7020	213	24	{123}
7021	213	25	{130}
7022	213	26	{133}
7023	213	27	{139}
7024	213	28	{145}
7025	213	29	{155}
7026	213	30	{157}
7027	213	31	{163}
7028	213	32	{172}
7029	213	33	{178,179,181}
7030	214	1	{1}
7031	214	2	{6}
7032	214	3	{12}
7033	214	4	{17}
7034	214	5	{22}
7035	214	6	{27}
7036	214	7	{31}
7037	214	8	{36}
7038	214	9	{46,44}
7039	214	10	{51,52}
7040	214	11	{57}
7041	214	12	{63}
7042	214	13	{67}
7043	214	14	{73}
7044	214	15	{78}
7045	214	16	{83}
7046	214	17	{87}
7047	214	18	{93}
7048	214	19	{98}
7049	214	20	{103}
7050	214	21	{108}
7051	214	22	{114}
7052	214	23	{118}
7053	214	24	{122}
7054	214	25	{131}
7055	214	26	{135,134}
7056	214	27	{140}
7057	214	28	{144}
7058	214	29	{151,155}
7059	214	30	{157}
7060	214	31	{161}
7061	214	32	{170}
7062	214	33	{173}
7063	215	1	{2}
7064	215	2	{7}
7065	215	3	{12}
7066	215	4	{16}
7067	215	5	{22}
7068	215	6	{26}
7069	215	7	{32}
7070	215	8	{37}
7071	215	9	{48,44,45}
7072	215	10	{55}
7073	215	11	{58}
7074	215	12	{63}
7075	215	13	{69}
7076	215	14	{76}
7077	215	15	{77}
7078	215	16	{82}
7079	215	17	{88}
7080	215	18	{92}
7081	215	19	{98}
7082	215	20	{104}
7083	215	21	{111}
7084	215	22	{114}
7085	215	23	{118}
7086	215	24	{122}
7087	215	25	{127}
7088	215	26	{134,136,137}
7089	215	27	{138}
7090	215	28	{143}
7091	215	29	{150,155}
7092	215	30	{159}
7093	215	31	{166}
7094	215	32	{171}
7095	215	33	{181,180}
7096	216	1	{1}
7097	216	2	{7}
7098	216	3	{12}
7099	216	4	{17}
7100	216	5	{22}
7101	216	6	{28}
7102	216	7	{32}
7103	216	8	{37}
7104	216	9	{48,46}
7105	216	10	{56}
7106	216	11	{57}
7107	216	12	{64}
7108	216	13	{68}
7109	216	14	{72}
7110	216	15	{78}
7111	216	16	{82}
7112	216	17	{88}
7113	216	18	{93}
7114	216	19	{98}
7115	216	20	{103}
7116	216	21	{108}
7117	216	22	{113}
7118	216	23	{118}
7119	216	24	{124}
7120	216	25	{129}
7121	216	26	{133,134,137}
7122	216	27	{140}
7123	216	28	{144}
7124	216	29	{152,149}
7125	216	30	{157}
7126	216	31	{161,162,165}
7127	216	32	{171}
7128	216	33	{176,175}
7129	217	1	{4}
7130	217	2	{7}
7131	217	3	{12}
7132	217	4	{18}
7133	217	5	{22}
7134	217	6	{28}
7135	217	7	{32}
7136	217	8	{37}
7137	217	9	{48,46,47}
7138	217	10	{50,56}
7139	217	11	{58}
7140	217	12	{63}
7141	217	13	{68}
7142	217	14	{73}
7143	217	15	{78}
7144	217	16	{83}
7145	217	17	{91}
7146	217	18	{94}
7147	217	19	{98}
7148	217	20	{104}
7149	217	21	{110}
7150	217	22	{114}
7151	217	23	{118}
7152	217	24	{123}
7153	217	25	{128}
7154	217	26	{135}
7155	217	27	{140}
7156	217	28	{144}
7157	217	29	{153,154,155}
7158	217	30	{157}
7159	217	31	{166,161,162}
7160	217	32	{171}
7161	217	33	{174}
7162	218	1	{3}
7163	218	2	{7}
7164	218	3	{11}
7165	218	4	{17}
7166	218	5	{23}
7167	218	6	{26}
7168	218	7	{31}
7169	218	8	{37}
7170	218	9	{48,43}
7171	218	10	{53}
7172	218	11	{59}
7173	218	12	{63}
7174	218	13	{68}
7175	218	14	{72}
7176	218	15	{78}
7177	218	16	{83}
7178	218	17	{87}
7179	218	18	{93}
7180	218	19	{98}
7181	218	20	{103}
7182	218	21	{111}
7183	218	22	{113}
7184	218	23	{118}
7185	218	24	{124}
7186	218	25	{129}
7187	218	26	{135,136,137}
7188	218	27	{138}
7189	218	28	{144}
7190	218	29	{148,149}
7191	218	30	{159}
7192	218	31	{168}
7193	218	32	{170}
7194	218	33	{181,180}
7195	219	1	{2}
7196	219	2	{7}
7197	219	3	{12}
7198	219	4	{17}
7199	219	5	{22}
7200	219	6	{27}
7201	219	7	{31}
7202	219	8	{37}
7203	219	9	{48,45}
7204	219	10	{49}
7205	219	11	{58}
7206	219	12	{63}
7207	219	13	{68}
7208	219	14	{73}
7209	219	15	{79}
7210	219	16	{83}
7211	219	17	{87}
7212	219	18	{93}
7213	219	19	{98}
7214	219	20	{105}
7215	219	21	{109}
7216	219	22	{113}
7217	219	23	{118}
7218	219	24	{122}
7219	219	25	{128}
7220	219	26	{132}
7221	219	27	{139}
7222	219	28	{143}
7223	219	29	{151,154}
7224	219	30	{160}
7225	219	31	{165}
7226	219	32	{170}
7227	219	33	{178,176,180}
7228	220	1	{2}
7229	220	2	{7}
7230	220	3	{11}
7231	220	4	{18}
7232	220	5	{22}
7233	220	6	{26}
7234	220	7	{31}
7235	220	8	{37}
7236	220	9	{48,44}
7237	220	10	{56,49}
7238	220	11	{58}
7239	220	12	{62}
7240	220	13	{70}
7241	220	14	{73}
7242	220	15	{78}
7243	220	16	{83}
7244	220	17	{88}
7245	220	18	{93}
7246	220	19	{98}
7247	220	20	{103}
7248	220	21	{109}
7249	220	22	{113}
7250	220	23	{118}
7251	220	24	{124}
7252	220	25	{127}
7253	220	26	{133,135,137}
7254	220	27	{139}
7255	220	28	{144}
7256	220	29	{148,152,150}
7257	220	30	{157}
7258	220	31	{166,161,162}
7259	220	32	{170}
7260	220	33	{180}
7261	221	1	{3}
7262	221	2	{10}
7263	221	3	{11}
7264	221	4	{17}
7265	221	5	{22}
7266	221	6	{27}
7267	221	7	{33}
7268	221	8	{36}
7269	221	9	{44,45}
7270	221	10	{54,53,52}
7271	221	11	{59}
7272	221	12	{62}
7273	221	13	{67}
7274	221	14	{74}
7275	221	15	{78}
7276	221	16	{83}
7277	221	17	{88}
7278	221	18	{92}
7279	221	19	{99}
7280	221	20	{103}
7281	221	21	{109}
7282	221	22	{113}
7283	221	23	{118}
7284	221	24	{123}
7285	221	25	{128}
7286	221	26	{132,135}
7287	221	27	{140}
7288	221	28	{145}
7289	221	29	{153,150,149}
7290	221	30	{160}
7291	221	31	{168}
7292	221	32	{172}
7293	221	33	{178,181,174}
7294	222	1	{1}
7295	222	2	{7}
7296	222	3	{12}
7297	222	4	{17}
7298	222	5	{23}
7299	222	6	{27}
7300	222	7	{32}
7301	222	8	{36}
7302	222	9	{42,46,45}
7303	222	10	{53,55,56}
7304	222	11	{58}
7305	222	12	{64}
7306	222	13	{69}
7307	222	14	{76}
7308	222	15	{77}
7309	222	16	{84}
7310	222	17	{88}
7311	222	18	{93}
7312	222	19	{98}
7313	222	20	{102}
7314	222	21	{109}
7315	222	22	{115}
7316	222	23	{118}
7317	222	24	{124}
7318	222	25	{127}
7319	222	26	{132,135,136}
7320	222	27	{139}
7321	222	28	{144}
7322	222	29	{151,152,155}
7323	222	30	{158}
7324	222	31	{163,168}
7325	222	32	{172}
7326	222	33	{180}
7327	223	1	{2}
7328	223	2	{7}
7329	223	3	{12}
7330	223	4	{16}
7331	223	5	{22}
7332	223	6	{27}
7333	223	7	{33}
7334	223	8	{37}
7335	223	9	{43,45}
7336	223	10	{54,55}
7337	223	11	{57}
7338	223	12	{62}
7339	223	13	{68}
7340	223	14	{75}
7341	223	15	{78}
7342	223	16	{82}
7343	223	17	{88}
7344	223	18	{93}
7345	223	19	{98}
7346	223	20	{103}
7347	223	21	{109}
7348	223	22	{113}
7349	223	23	{117}
7350	223	24	{123}
7351	223	25	{128}
7352	223	26	{134}
7353	223	27	{140}
7354	223	28	{145}
7355	223	29	{153,154,155}
7356	223	30	{160}
7357	223	31	{163,167,169}
7358	223	32	{170}
7359	223	33	{176}
7360	224	1	{2}
7361	224	2	{7}
7362	224	3	{11}
7363	224	4	{17}
7364	224	5	{22}
7365	224	6	{27}
7366	224	7	{34}
7367	224	8	{37}
7368	224	9	{41}
7369	224	10	{54}
7370	224	11	{58}
7371	224	12	{63}
7372	224	13	{69}
7373	224	14	{73}
7374	224	15	{78}
7375	224	16	{83}
7376	224	17	{88}
7377	224	18	{92}
7378	224	19	{97}
7379	224	20	{102}
7380	224	21	{110}
7381	224	22	{113}
7382	224	23	{118}
7383	224	24	{122}
7384	224	25	{128}
7385	224	26	{133,135,136}
7386	224	27	{139}
7387	224	28	{143}
7388	224	29	{148,153}
7389	224	30	{158}
7390	224	31	{167,166}
7391	224	32	{172}
7392	224	33	{176}
7393	225	1	{2}
7394	225	2	{7}
7395	225	3	{12}
7396	225	4	{18}
7397	225	5	{23}
7398	225	6	{27}
7399	225	7	{31}
7400	225	8	{36}
7401	225	9	{48,43,41}
7402	225	10	{55,49}
7403	225	11	{58}
7404	225	12	{62}
7405	225	13	{68}
7406	225	14	{73}
7407	225	15	{77}
7408	225	16	{83}
7409	225	17	{88}
7410	225	18	{93}
7411	225	19	{98}
7412	225	20	{103}
7413	225	21	{109}
7414	225	22	{115}
7415	225	23	{118}
7416	225	24	{123}
7417	225	25	{128}
7418	225	26	{133,137}
7419	225	27	{139}
7420	225	28	{143}
7421	225	29	{153,152,155}
7422	225	30	{160}
7423	225	31	{167,168}
7424	225	32	{170}
7425	225	33	{177}
7426	226	1	{2}
7427	226	2	{7}
7428	226	3	{12}
7429	226	4	{17}
7430	226	5	{22}
7431	226	6	{27}
7432	226	7	{33}
7433	226	8	{37}
7434	226	9	{47,45}
7435	226	10	{50,55,56}
7436	226	11	{58}
7437	226	12	{63}
7438	226	13	{68}
7439	226	14	{73}
7440	226	15	{78}
7441	226	16	{83}
7442	226	17	{88}
7443	226	18	{96}
7444	226	19	{98}
7445	226	20	{104}
7446	226	21	{111}
7447	226	22	{113}
7448	226	23	{119}
7449	226	24	{123}
7450	226	25	{130}
7451	226	26	{136,137}
7452	226	27	{140}
7453	226	28	{144}
7454	226	29	{152}
7455	226	30	{157}
7456	226	31	{166}
7457	226	32	{170}
7458	226	33	{177}
7459	227	1	{3}
7460	227	2	{7}
7461	227	3	{12}
7462	227	4	{17}
7463	227	5	{24}
7464	227	6	{28}
7465	227	7	{32}
7466	227	8	{37}
7467	227	9	{42,44}
7468	227	10	{53,55}
7469	227	11	{57}
7470	227	12	{63}
7471	227	13	{68}
7472	227	14	{72}
7473	227	15	{78}
7474	227	16	{85}
7475	227	17	{88}
7476	227	18	{93}
7477	227	19	{98}
7478	227	20	{103}
7479	227	21	{109}
7480	227	22	{113}
7481	227	23	{119}
7482	227	24	{123}
7483	227	25	{128}
7484	227	26	{135}
7485	227	27	{139}
7486	227	28	{143}
7487	227	29	{153,155}
7488	227	30	{156}
7489	227	31	{161,162,164}
7490	227	32	{172}
7491	227	33	{173}
7492	228	1	{3}
7493	228	2	{7}
7494	228	3	{12}
7495	228	4	{18}
7496	228	5	{22}
7497	228	6	{27}
7498	228	7	{33}
7499	228	8	{36}
7500	228	9	{44,43}
7501	228	10	{54,53}
7502	228	11	{58}
7503	228	12	{63}
7504	228	13	{67}
7505	228	14	{76}
7506	228	15	{78}
7507	228	16	{83}
7508	228	17	{88}
7509	228	18	{92}
7510	228	19	{99}
7511	228	20	{102}
7512	228	21	{108}
7513	228	22	{113}
7514	228	23	{118}
7515	228	24	{124}
7516	228	25	{128}
7517	228	26	{132,136}
7518	228	27	{139}
7519	228	28	{145}
7520	228	29	{153}
7521	228	30	{156}
7522	228	31	{167,161,169}
7523	228	32	{172}
7524	228	33	{178,176,175}
7525	229	1	{2}
7526	229	2	{7}
7527	229	3	{12}
7528	229	4	{17}
7529	229	5	{21}
7530	229	6	{30}
7531	229	7	{32}
7532	229	8	{37}
7533	229	9	{48,46}
7534	229	10	{55,56}
7535	229	11	{59}
7536	229	12	{62}
7537	229	13	{68}
7538	229	14	{73}
7539	229	15	{78}
7540	229	16	{82}
7541	229	17	{87}
7542	229	18	{94}
7543	229	19	{98}
7544	229	20	{103}
7545	229	21	{110}
7546	229	22	{112}
7547	229	23	{118}
7548	229	24	{123}
7549	229	25	{129}
7550	229	26	{133,135}
7551	229	27	{139}
7552	229	28	{144}
7553	229	29	{148,153,154}
7554	229	30	{159}
7555	229	31	{166,168,169}
7556	229	32	{171}
7557	229	33	{176}
7558	230	1	{2}
7559	230	2	{7}
7560	230	3	{12}
7561	230	4	{16}
7562	230	5	{22}
7563	230	6	{27}
7564	230	7	{33}
7565	230	8	{37}
7566	230	9	{41,45}
7567	230	10	{54,51,52}
7568	230	11	{58}
7569	230	12	{64}
7570	230	13	{67}
7571	230	14	{74}
7572	230	15	{78}
7573	230	16	{83}
7574	230	17	{88}
7575	230	18	{93}
7576	230	19	{98}
7577	230	20	{104}
7578	230	21	{109}
7579	230	22	{113}
7580	230	23	{118}
7581	230	24	{122}
7582	230	25	{128}
7583	230	26	{132,136,137}
7584	230	27	{138}
7585	230	28	{144}
7586	230	29	{153,155}
7587	230	30	{159}
7588	230	31	{167,166}
7589	230	32	{170}
7590	230	33	{181,174}
7591	231	1	{1}
7592	231	2	{7}
7593	231	3	{12}
7594	231	4	{17}
7595	231	5	{22}
7596	231	6	{27}
7597	231	7	{32}
7598	231	8	{36}
7599	231	9	{41,47}
7600	231	10	{54,50,55}
7601	231	11	{58}
7602	231	12	{63}
7603	231	13	{68}
7604	231	14	{73}
7605	231	15	{77}
7606	231	16	{83}
7607	231	17	{87}
7608	231	18	{93}
7609	231	19	{98}
7610	231	20	{104}
7611	231	21	{109}
7612	231	22	{113}
7613	231	23	{118}
7614	231	24	{123}
7615	231	25	{128}
7616	231	26	{133,137}
7617	231	27	{139}
7618	231	28	{145}
7619	231	29	{150}
7620	231	30	{160}
7621	231	31	{163}
7622	231	32	{172}
7623	231	33	{176,175}
7624	232	1	{1}
7625	232	2	{6}
7626	232	3	{13}
7627	232	4	{17}
7628	232	5	{22}
7629	232	6	{26}
7630	232	7	{35}
7631	232	8	{37}
7632	232	9	{41,47,45}
7633	232	10	{51,49}
7634	232	11	{58}
7635	232	12	{62}
7636	232	13	{68}
7637	232	14	{74}
7638	232	15	{79}
7639	232	16	{82}
7640	232	17	{88}
7641	232	18	{94}
7642	232	19	{98}
7643	232	20	{103}
7644	232	21	{110}
7645	232	22	{113}
7646	232	23	{118}
7647	232	24	{123}
7648	232	25	{129}
7649	232	26	{132}
7650	232	27	{139}
7651	232	28	{144}
7652	232	29	{152,150,155}
7653	232	30	{160}
7654	232	31	{162}
7655	232	32	{170}
7656	232	33	{181,174,173}
7657	233	1	{2}
7658	233	2	{7}
7659	233	3	{11}
7660	233	4	{17}
7661	233	5	{21}
7662	233	6	{27}
7663	233	7	{32}
7664	233	8	{39}
7665	233	9	{43}
7666	233	10	{49}
7667	233	11	{58}
7668	233	12	{63}
7669	233	13	{69}
7670	233	14	{75}
7671	233	15	{78}
7672	233	16	{83}
7673	233	17	{88}
7674	233	18	{94}
7675	233	19	{100}
7676	233	20	{103}
7677	233	21	{110}
7678	233	22	{113}
7679	233	23	{118}
7680	233	24	{123}
7681	233	25	{129}
7682	233	26	{132,135}
7683	233	27	{139}
7684	233	28	{145}
7685	233	29	{151,148,154}
7686	233	30	{158}
7687	233	31	{163,167,165}
7688	233	32	{171}
7689	233	33	{179,181,180}
7690	234	1	{1}
7691	234	2	{7}
7692	234	3	{12}
7693	234	4	{17}
7694	234	5	{22}
7695	234	6	{28}
7696	234	7	{32}
7697	234	8	{38}
7698	234	9	{47,45}
7699	234	10	{49}
7700	234	11	{58}
7701	234	12	{63}
7702	234	13	{69}
7703	234	14	{73}
7704	234	15	{79}
7705	234	16	{83}
7706	234	17	{88}
7707	234	18	{93}
7708	234	19	{99}
7709	234	20	{103}
7710	234	21	{110}
7711	234	22	{114}
7712	234	23	{118}
7713	234	24	{123}
7714	234	25	{128}
7715	234	26	{133,136}
7716	234	27	{139}
7717	234	28	{144}
7718	234	29	{153,154}
7719	234	30	{160}
7720	234	31	{161,164}
7721	234	32	{171}
7722	234	33	{181,174}
7723	235	1	{2}
7724	235	2	{8}
7725	235	3	{14}
7726	235	4	{17}
7727	235	5	{22}
7728	235	6	{27}
7729	235	7	{32}
7730	235	8	{38}
7731	235	9	{45}
7732	235	10	{53,49}
7733	235	11	{58}
7734	235	12	{63}
7735	235	13	{68}
7736	235	14	{73}
7737	235	15	{77}
7738	235	16	{83}
7739	235	17	{89}
7740	235	18	{96}
7741	235	19	{99}
7742	235	20	{103}
7743	235	21	{109}
7744	235	22	{116}
7745	235	23	{117}
7746	235	24	{124}
7747	235	25	{128}
7748	235	26	{135,134}
7749	235	27	{138}
7750	235	28	{144}
7751	235	29	{148,152,150}
7752	235	30	{156}
7753	235	31	{168,165}
7754	235	32	{171}
7755	235	33	{180,173}
7756	236	1	{2}
7757	236	2	{7}
7758	236	3	{12}
7759	236	4	{18}
7760	236	5	{22}
7761	236	6	{28}
7762	236	7	{32}
7763	236	8	{37}
7764	236	9	{46,47}
7765	236	10	{54}
7766	236	11	{58}
7767	236	12	{63}
7768	236	13	{68}
7769	236	14	{73}
7770	236	15	{79}
7771	236	16	{85}
7772	236	17	{87}
7773	236	18	{93}
7774	236	19	{100}
7775	236	20	{103}
7776	236	21	{109}
7777	236	22	{113}
7778	236	23	{119}
7779	236	24	{123}
7780	236	25	{128}
7781	236	26	{137}
7782	236	27	{140}
7783	236	28	{147}
7784	236	29	{148,152,155}
7785	236	30	{160}
7786	236	31	{161}
7787	236	32	{170}
7788	236	33	{180,177,173}
7789	237	1	{2}
7790	237	2	{7}
7791	237	3	{12}
7792	237	4	{17}
7793	237	5	{22}
7794	237	6	{30}
7795	237	7	{32}
7796	237	8	{38}
7797	237	9	{42,48}
7798	237	10	{51,49,52}
7799	237	11	{58}
7800	237	12	{66}
7801	237	13	{68}
7802	237	14	{74}
7803	237	15	{78}
7804	237	16	{86}
7805	237	17	{89}
7806	237	18	{93}
7807	237	19	{97}
7808	237	20	{102}
7809	237	21	{108}
7810	237	22	{113}
7811	237	23	{118}
7812	237	24	{126}
7813	237	25	{128}
7814	237	26	{132,135}
7815	237	27	{139}
7816	237	28	{144}
7817	237	29	{148,152,149}
7818	237	30	{157}
7819	237	31	{167,165,164}
7820	237	32	{171}
7821	237	33	{179,175}
7822	238	1	{2}
7823	238	2	{7}
7824	238	3	{12}
7825	238	4	{17}
7826	238	5	{23}
7827	238	6	{26}
7828	238	7	{32}
7829	238	8	{37}
7830	238	9	{48}
7831	238	10	{56,49,52}
7832	238	11	{58}
7833	238	12	{64}
7834	238	13	{69}
7835	238	14	{73}
7836	238	15	{78}
7837	238	16	{83}
7838	238	17	{88}
7839	238	18	{93}
7840	238	19	{98}
7841	238	20	{103}
7842	238	21	{109}
7843	238	22	{113}
7844	238	23	{118}
7845	238	24	{122}
7846	238	25	{127}
7847	238	26	{133,137}
7848	238	27	{138}
7849	238	28	{143}
7850	238	29	{150}
7851	238	30	{157}
7852	238	31	{167,166,162}
7853	238	32	{171}
7854	238	33	{181}
7855	239	1	{2}
7856	239	2	{7}
7857	239	3	{12}
7858	239	4	{16}
7859	239	5	{22}
7860	239	6	{27}
7861	239	7	{32}
7862	239	8	{37}
7863	239	9	{44}
7864	239	10	{53,50,55}
7865	239	11	{58}
7866	239	12	{63}
7867	239	13	{69}
7868	239	14	{72}
7869	239	15	{77}
7870	239	16	{83}
7871	239	17	{88}
7872	239	18	{93}
7873	239	19	{98}
7874	239	20	{103}
7875	239	21	{109}
7876	239	22	{112}
7877	239	23	{118}
7878	239	24	{122}
7879	239	25	{127}
7880	239	26	{134,136}
7881	239	27	{139}
7882	239	28	{144}
7883	239	29	{151,148,153}
7884	239	30	{156}
7885	239	31	{166,168,169}
7886	239	32	{170}
7887	239	33	{180}
7888	240	1	{2}
7889	240	2	{7}
7890	240	3	{12}
7891	240	4	{17}
7892	240	5	{22}
7893	240	6	{28}
7894	240	7	{33}
7895	240	8	{37}
7896	240	9	{42,43,45}
7897	240	10	{53,56}
7898	240	11	{58}
7899	240	12	{62}
7900	240	13	{69}
7901	240	14	{73}
7902	240	15	{78}
7903	240	16	{84}
7904	240	17	{89}
7905	240	18	{93}
7906	240	19	{98}
7907	240	20	{102}
7908	240	21	{109}
7909	240	22	{113}
7910	240	23	{119}
7911	240	24	{122}
7912	240	25	{129}
7913	240	26	{132,134,137}
7914	240	27	{139}
7915	240	28	{144}
7916	240	29	{153,149}
7917	240	30	{158}
7918	240	31	{162,164}
7919	240	32	{170}
7920	240	33	{175,177}
7921	241	1	{2}
7922	241	2	{7}
7923	241	3	{12}
7924	241	4	{17}
7925	241	5	{22}
7926	241	6	{28}
7927	241	7	{35}
7928	241	8	{40}
7929	241	9	{42,44}
7930	241	10	{54,51,55}
7931	241	11	{58}
7932	241	12	{63}
7933	241	13	{68}
7934	241	14	{73}
7935	241	15	{79}
7936	241	16	{84}
7937	241	17	{88}
7938	241	18	{93}
7939	241	19	{98}
7940	241	20	{103}
7941	241	21	{109}
7942	241	22	{113}
7943	241	23	{117}
7944	241	24	{122}
7945	241	25	{128}
7946	241	26	{132}
7947	241	27	{138}
7948	241	28	{144}
7949	241	29	{148}
7950	241	30	{157}
7951	241	31	{166}
7952	241	32	{172}
7953	241	33	{175,174}
7954	242	1	{2}
7955	242	2	{7}
7956	242	3	{13}
7957	242	4	{17}
7958	242	5	{21}
7959	242	6	{27}
7960	242	7	{32}
7961	242	8	{37}
7962	242	9	{48,46,47}
7963	242	10	{54}
7964	242	11	{58}
7965	242	12	{63}
7966	242	13	{68}
7967	242	14	{73}
7968	242	15	{79}
7969	242	16	{82}
7970	242	17	{88}
7971	242	18	{93}
7972	242	19	{98}
7973	242	20	{102}
7974	242	21	{110}
7975	242	22	{113}
7976	242	23	{120}
7977	242	24	{123}
7978	242	25	{129}
7979	242	26	{133,135}
7980	242	27	{139}
7981	242	28	{144}
7982	242	29	{151,148,149}
7983	242	30	{158}
7984	242	31	{168}
7985	242	32	{171}
7986	242	33	{178,173}
7987	243	1	{2}
7988	243	2	{9}
7989	243	3	{12}
7990	243	4	{16}
7991	243	5	{21}
7992	243	6	{29}
7993	243	7	{31}
7994	243	8	{37}
7995	243	9	{45}
7996	243	10	{55}
7997	243	11	{57}
7998	243	12	{63}
7999	243	13	{68}
8000	243	14	{73}
8001	243	15	{78}
8002	243	16	{83}
8003	243	17	{87}
8004	243	18	{93}
8005	243	19	{99}
8006	243	20	{102}
8007	243	21	{109}
8008	243	22	{114}
8009	243	23	{117}
8010	243	24	{123}
8011	243	25	{128}
8012	243	26	{135,134,136}
8013	243	27	{139}
8014	243	28	{144}
8015	243	29	{152,154,155}
8016	243	30	{159}
8017	243	31	{164}
8018	243	32	{170}
8019	243	33	{178,179}
8020	244	1	{2}
8021	244	2	{8}
8022	244	3	{11}
8023	244	4	{16}
8024	244	5	{22}
8025	244	6	{27}
8026	244	7	{32}
8027	244	8	{37}
8028	244	9	{43}
8029	244	10	{53,56}
8030	244	11	{58}
8031	244	12	{64}
8032	244	13	{68}
8033	244	14	{73}
8034	244	15	{78}
8035	244	16	{83}
8036	244	17	{87}
8037	244	18	{94}
8038	244	19	{98}
8039	244	20	{103}
8040	244	21	{110}
8041	244	22	{113}
8042	244	23	{117}
8043	244	24	{123}
8044	244	25	{128}
8045	244	26	{132}
8046	244	27	{139}
8047	244	28	{144}
8048	244	29	{149}
8049	244	30	{159}
8050	244	31	{166,165}
8051	244	32	{171}
8052	244	33	{179}
8053	245	1	{5}
8054	245	2	{7}
8055	245	3	{11}
8056	245	4	{17}
8057	245	5	{21}
8058	245	6	{26}
8059	245	7	{32}
8060	245	8	{38}
8061	245	9	{42,48,44}
8062	245	10	{53,49}
8063	245	11	{58}
8064	245	12	{64}
8065	245	13	{67}
8066	245	14	{72}
8067	245	15	{78}
8068	245	16	{83}
8069	245	17	{88}
8070	245	18	{94}
8071	245	19	{99}
8072	245	20	{103}
8073	245	21	{109}
8074	245	22	{113}
8075	245	23	{118}
8076	245	24	{123}
8077	245	25	{128}
8078	245	26	{133,135,134}
8079	245	27	{139}
8080	245	28	{144}
8081	245	29	{152,150}
8082	245	30	{158}
8083	245	31	{163,166,169}
8084	245	32	{171}
8085	245	33	{179}
8086	246	1	{3}
8087	246	2	{7}
8088	246	3	{12}
8089	246	4	{17}
8090	246	5	{23}
8091	246	6	{26}
8092	246	7	{33}
8093	246	8	{37}
8094	246	9	{44,47,45}
8095	246	10	{53,50,49}
8096	246	11	{58}
8097	246	12	{62}
8098	246	13	{68}
8099	246	14	{73}
8100	246	15	{78}
8101	246	16	{83}
8102	246	17	{89}
8103	246	18	{92}
8104	246	19	{97}
8105	246	20	{103}
8106	246	21	{109}
8107	246	22	{113}
8108	246	23	{118}
8109	246	24	{125}
8110	246	25	{128}
8111	246	26	{133,136,137}
8112	246	27	{139}
8113	246	28	{144}
8114	246	29	{153,150,149}
8115	246	30	{158}
8116	246	31	{167}
8117	246	32	{170}
8118	246	33	{178,181,173}
8119	247	1	{1}
8120	247	2	{6}
8121	247	3	{11}
8122	247	4	{17}
8123	247	5	{22}
8124	247	6	{28}
8125	247	7	{32}
8126	247	8	{38}
8127	247	9	{48,46}
8128	247	10	{51,56}
8129	247	11	{58}
8130	247	12	{62}
8131	247	13	{68}
8132	247	14	{74}
8133	247	15	{78}
8134	247	16	{83}
8135	247	17	{89}
8136	247	18	{93}
8137	247	19	{99}
8138	247	20	{103}
8139	247	21	{111}
8140	247	22	{113}
8141	247	23	{118}
8142	247	24	{123}
8143	247	25	{129}
8144	247	26	{132,136}
8145	247	27	{139}
8146	247	28	{144}
8147	247	29	{151,149}
8148	247	30	{158}
8149	247	31	{163,165}
8150	247	32	{171}
8151	247	33	{179,175,177}
8152	248	1	{3}
8153	248	2	{7}
8154	248	3	{12}
8155	248	4	{18}
8156	248	5	{22}
8157	248	6	{28}
8158	248	7	{31}
8159	248	8	{37}
8160	248	9	{45}
8161	248	10	{54}
8162	248	11	{59}
8163	248	12	{62}
8164	248	13	{68}
8165	248	14	{73}
8166	248	15	{79}
8167	248	16	{83}
8168	248	17	{87}
8169	248	18	{96}
8170	248	19	{98}
8171	248	20	{103}
8172	248	21	{109}
8173	248	22	{113}
8174	248	23	{118}
8175	248	24	{123}
8176	248	25	{127}
8177	248	26	{134}
8178	248	27	{141}
8179	248	28	{144}
8180	248	29	{155}
8181	248	30	{156}
8182	248	31	{168}
8183	248	32	{172}
8184	248	33	{179,181}
8185	249	1	{3}
8186	249	2	{7}
8187	249	3	{11}
8188	249	4	{17}
8189	249	5	{23}
8190	249	6	{28}
8191	249	7	{32}
8192	249	8	{38}
8193	249	9	{48,45}
8194	249	10	{54,55,56}
8195	249	11	{57}
8196	249	12	{64}
8197	249	13	{69}
8198	249	14	{73}
8199	249	15	{81}
8200	249	16	{83}
8201	249	17	{88}
8202	249	18	{93}
8203	249	19	{98}
8204	249	20	{102}
8205	249	21	{110}
8206	249	22	{113}
8207	249	23	{119}
8208	249	24	{126}
8209	249	25	{127}
8210	249	26	{132}
8211	249	27	{139}
8212	249	28	{145}
8213	249	29	{151,148,149}
8214	249	30	{156}
8215	249	31	{168,165}
8216	249	32	{171}
8217	249	33	{181,180,174}
8218	250	1	{2}
8219	250	2	{7}
8220	250	3	{12}
8221	250	4	{18}
8222	250	5	{21}
8223	250	6	{27}
8224	250	7	{33}
8225	250	8	{37}
8226	250	9	{42,46}
8227	250	10	{54,55,52}
8228	250	11	{58}
8229	250	12	{66}
8230	250	13	{68}
8231	250	14	{73}
8232	250	15	{78}
8233	250	16	{84}
8234	250	17	{88}
8235	250	18	{92}
8236	250	19	{98}
8237	250	20	{104}
8238	250	21	{108}
8239	250	22	{114}
8240	250	23	{119}
8241	250	24	{124}
8242	250	25	{128}
8243	250	26	{135}
8244	250	27	{138}
8245	250	28	{143}
8246	250	29	{148,152}
8247	250	30	{156}
8248	250	31	{169}
8249	250	32	{171}
8250	250	33	{174,177,173}
8251	251	1	{1}
8252	251	2	{8}
8253	251	3	{12}
8254	251	4	{18}
8255	251	5	{23}
8256	251	6	{27}
8257	251	7	{32}
8258	251	8	{36}
8259	251	9	{44,43}
8260	251	10	{52}
8261	251	11	{58}
8262	251	12	{63}
8263	251	13	{68}
8264	251	14	{72}
8265	251	15	{78}
8266	251	16	{83}
8267	251	17	{87}
8268	251	18	{94}
8269	251	19	{97}
8270	251	20	{103}
8271	251	21	{109}
8272	251	22	{112}
8273	251	23	{118}
8274	251	24	{123}
8275	251	25	{129}
8276	251	26	{133}
8277	251	27	{140}
8278	251	28	{147}
8279	251	29	{148,154}
8280	251	30	{160}
8281	251	31	{162,165}
8282	251	32	{171}
8283	251	33	{176,180,177}
8284	252	1	{3}
8285	252	2	{7}
8286	252	3	{12}
8287	252	4	{17}
8288	252	5	{22}
8289	252	6	{27}
8290	252	7	{33}
8291	252	8	{36}
8292	252	9	{44,41,45}
8293	252	10	{53,50,51}
8294	252	11	{58}
8295	252	12	{66}
8296	252	13	{68}
8297	252	14	{75}
8298	252	15	{78}
8299	252	16	{84}
8300	252	17	{88}
8301	252	18	{93}
8302	252	19	{98}
8303	252	20	{102}
8304	252	21	{109}
8305	252	22	{114}
8306	252	23	{118}
8307	252	24	{124}
8308	252	25	{129}
8309	252	26	{135}
8310	252	27	{139}
8311	252	28	{145}
8312	252	29	{148,150,155}
8313	252	30	{156}
8314	252	31	{167,168,169}
8315	252	32	{172}
8316	252	33	{178,181}
8317	253	1	{2}
8318	253	2	{7}
8319	253	3	{11}
8320	253	4	{17}
8321	253	5	{25}
8322	253	6	{27}
8323	253	7	{31}
8324	253	8	{36}
8325	253	9	{48}
8326	253	10	{56,49,52}
8327	253	11	{59}
8328	253	12	{62}
8329	253	13	{67}
8330	253	14	{73}
8331	253	15	{78}
8332	253	16	{84}
8333	253	17	{91}
8334	253	18	{93}
8335	253	19	{99}
8336	253	20	{103}
8337	253	21	{108}
8338	253	22	{115}
8339	253	23	{118}
8340	253	24	{125}
8341	253	25	{129}
8342	253	26	{133,132}
8343	253	27	{142}
8344	253	28	{144}
8345	253	29	{152,149}
8346	253	30	{158}
8347	253	31	{169}
8348	253	32	{170}
8349	253	33	{180}
8350	254	1	{2}
8351	254	2	{9}
8352	254	3	{11}
8353	254	4	{17}
8354	254	5	{23}
8355	254	6	{27}
8356	254	7	{31}
8357	254	8	{36}
8358	254	9	{46,41}
8359	254	10	{53,51}
8360	254	11	{58}
8361	254	12	{62}
8362	254	13	{69}
8363	254	14	{74}
8364	254	15	{79}
8365	254	16	{83}
8366	254	17	{88}
8367	254	18	{95}
8368	254	19	{99}
8369	254	20	{103}
8370	254	21	{110}
8371	254	22	{112}
8372	254	23	{118}
8373	254	24	{124}
8374	254	25	{131}
8375	254	26	{133}
8376	254	27	{139}
8377	254	28	{145}
8378	254	29	{154}
8379	254	30	{160}
8380	254	31	{167,166,165}
8381	254	32	{172}
8382	254	33	{175,174}
8383	255	1	{2}
8384	255	2	{6}
8385	255	3	{12}
8386	255	4	{17}
8387	255	5	{21}
8388	255	6	{28}
8389	255	7	{31}
8390	255	8	{36}
8391	255	9	{44}
8392	255	10	{53,50}
8393	255	11	{59}
8394	255	12	{63}
8395	255	13	{68}
8396	255	14	{73}
8397	255	15	{79}
8398	255	16	{83}
8399	255	17	{90}
8400	255	18	{93}
8401	255	19	{98}
8402	255	20	{102}
8403	255	21	{108}
8404	255	22	{112}
8405	255	23	{120}
8406	255	24	{123}
8407	255	25	{128}
8408	255	26	{135}
8409	255	27	{142}
8410	255	28	{144}
8411	255	29	{151,149}
8412	255	30	{159}
8413	255	31	{167,169}
8414	255	32	{172}
8415	255	33	{178,179,180}
8416	256	1	{2}
8417	256	2	{7}
8418	256	3	{12}
8419	256	4	{18}
8420	256	5	{21}
8421	256	6	{27}
8422	256	7	{32}
8423	256	8	{37}
8424	256	9	{42,46,43}
8425	256	10	{49}
8426	256	11	{57}
8427	256	12	{62}
8428	256	13	{67}
8429	256	14	{73}
8430	256	15	{78}
8431	256	16	{83}
8432	256	17	{88}
8433	256	18	{93}
8434	256	19	{97}
8435	256	20	{103}
8436	256	21	{108}
8437	256	22	{116}
8438	256	23	{118}
8439	256	24	{123}
8440	256	25	{128}
8441	256	26	{135,134,136}
8442	256	27	{139}
8443	256	28	{144}
8444	256	29	{148,152}
8445	256	30	{157}
8446	256	31	{166}
8447	256	32	{172}
8448	256	33	{178}
8449	257	1	{3}
8450	257	2	{6}
8451	257	3	{13}
8452	257	4	{16}
8453	257	5	{22}
8454	257	6	{26}
8455	257	7	{34}
8456	257	8	{37}
8457	257	9	{44,43,41}
8458	257	10	{49,52}
8459	257	11	{59}
8460	257	12	{65}
8461	257	13	{68}
8462	257	14	{72}
8463	257	15	{80}
8464	257	16	{83}
8465	257	17	{88}
8466	257	18	{94}
8467	257	19	{97}
8468	257	20	{103}
8469	257	21	{109}
8470	257	22	{113}
8471	257	23	{117}
8472	257	24	{123}
8473	257	25	{128}
8474	257	26	{133,135,134}
8475	257	27	{139}
8476	257	28	{143}
8477	257	29	{152}
8478	257	30	{158}
8479	257	31	{169,164}
8480	257	32	{172}
8481	257	33	{176,175,174}
8482	258	1	{1}
8483	258	2	{7}
8484	258	3	{12}
8485	258	4	{17}
8486	258	5	{22}
8487	258	6	{27}
8488	258	7	{32}
8489	258	8	{36}
8490	258	9	{43,41}
8491	258	10	{51}
8492	258	11	{58}
8493	258	12	{66}
8494	258	13	{68}
8495	258	14	{73}
8496	258	15	{78}
8497	258	16	{83}
8498	258	17	{88}
8499	258	18	{92}
8500	258	19	{98}
8501	258	20	{103}
8502	258	21	{109}
8503	258	22	{114}
8504	258	23	{118}
8505	258	24	{123}
8506	258	25	{129}
8507	258	26	{133,132,136}
8508	258	27	{140}
8509	258	28	{145}
8510	258	29	{148,150,155}
8511	258	30	{157}
8512	258	31	{165,164}
8513	258	32	{172}
8514	258	33	{179,181,173}
8515	259	1	{2}
8516	259	2	{8}
8517	259	3	{11}
8518	259	4	{17}
8519	259	5	{22}
8520	259	6	{28}
8521	259	7	{32}
8522	259	8	{36}
8523	259	9	{46}
8524	259	10	{51}
8525	259	11	{58}
8526	259	12	{62}
8527	259	13	{69}
8528	259	14	{73}
8529	259	15	{78}
8530	259	16	{83}
8531	259	17	{88}
8532	259	18	{93}
8533	259	19	{98}
8534	259	20	{102}
8535	259	21	{109}
8536	259	22	{113}
8537	259	23	{118}
8538	259	24	{123}
8539	259	25	{129}
8540	259	26	{134}
8541	259	27	{139}
8542	259	28	{145}
8543	259	29	{148,153,149}
8544	259	30	{157}
8545	259	31	{167,169,164}
8546	259	32	{171}
8547	259	33	{180}
8548	260	1	{2}
8549	260	2	{8}
8550	260	3	{12}
8551	260	4	{17}
8552	260	5	{22}
8553	260	6	{27}
8554	260	7	{32}
8555	260	8	{37}
8556	260	9	{48,46,44}
8557	260	10	{55,52}
8558	260	11	{58}
8559	260	12	{63}
8560	260	13	{68}
8561	260	14	{73}
8562	260	15	{78}
8563	260	16	{82}
8564	260	17	{88}
8565	260	18	{94}
8566	260	19	{98}
8567	260	20	{103}
8568	260	21	{110}
8569	260	22	{114}
8570	260	23	{118}
8571	260	24	{123}
8572	260	25	{128}
8573	260	26	{134}
8574	260	27	{139}
8575	260	28	{144}
8576	260	29	{154}
8577	260	30	{157}
8578	260	31	{167,162,165}
8579	260	32	{170}
8580	260	33	{179,176}
8581	261	1	{2}
8582	261	2	{9}
8583	261	3	{12}
8584	261	4	{17}
8585	261	5	{22}
8586	261	6	{27}
8587	261	7	{32}
8588	261	8	{36}
8589	261	9	{46,41}
8590	261	10	{53,50,51}
8591	261	11	{58}
8592	261	12	{62}
8593	261	13	{69}
8594	261	14	{73}
8595	261	15	{79}
8596	261	16	{84}
8597	261	17	{88}
8598	261	18	{93}
8599	261	19	{100}
8600	261	20	{102}
8601	261	21	{108}
8602	261	22	{113}
8603	261	23	{119}
8604	261	24	{124}
8605	261	25	{127}
8606	261	26	{136,137}
8607	261	27	{139}
8608	261	28	{144}
8609	261	29	{152,149}
8610	261	30	{159}
8611	261	31	{166}
8612	261	32	{171}
8613	261	33	{174,177}
8614	262	1	{1}
8615	262	2	{7}
8616	262	3	{12}
8617	262	4	{18}
8618	262	5	{22}
8619	262	6	{26}
8620	262	7	{32}
8621	262	8	{37}
8622	262	9	{46,44,43}
8623	262	10	{49,52}
8624	262	11	{58}
8625	262	12	{63}
8626	262	13	{67}
8627	262	14	{74}
8628	262	15	{78}
8629	262	16	{83}
8630	262	17	{87}
8631	262	18	{94}
8632	262	19	{99}
8633	262	20	{103}
8634	262	21	{109}
8635	262	22	{113}
8636	262	23	{118}
8637	262	24	{125}
8638	262	25	{131}
8639	262	26	{134,136}
8640	262	27	{138}
8641	262	28	{145}
8642	262	29	{148,154}
8643	262	30	{156}
8644	262	31	{162,165,164}
8645	262	32	{171}
8646	262	33	{181,173}
8647	263	1	{2}
8648	263	2	{8}
8649	263	3	{13}
8650	263	4	{18}
8651	263	5	{21}
8652	263	6	{27}
8653	263	7	{31}
8654	263	8	{37}
8655	263	9	{44,47,45}
8656	263	10	{54,53}
8657	263	11	{58}
8658	263	12	{62}
8659	263	13	{69}
8660	263	14	{72}
8661	263	15	{77}
8662	263	16	{83}
8663	263	17	{88}
8664	263	18	{93}
8665	263	19	{98}
8666	263	20	{102}
8667	263	21	{109}
8668	263	22	{113}
8669	263	23	{119}
8670	263	24	{126}
8671	263	25	{129}
8672	263	26	{133,136}
8673	263	27	{138}
8674	263	28	{143}
8675	263	29	{148,150,149}
8676	263	30	{156}
8677	263	31	{166,161,169}
8678	263	32	{171}
8679	263	33	{178,179}
8680	264	1	{2}
8681	264	2	{6}
8682	264	3	{13}
8683	264	4	{17}
8684	264	5	{22}
8685	264	6	{26}
8686	264	7	{32}
8687	264	8	{37}
8688	264	9	{46,41,45}
8689	264	10	{56}
8690	264	11	{57}
8691	264	12	{63}
8692	264	13	{69}
8693	264	14	{73}
8694	264	15	{78}
8695	264	16	{82}
8696	264	17	{87}
8697	264	18	{93}
8698	264	19	{98}
8699	264	20	{103}
8700	264	21	{109}
8701	264	22	{113}
8702	264	23	{119}
8703	264	24	{123}
8704	264	25	{128}
8705	264	26	{133,134}
8706	264	27	{138}
8707	264	28	{143}
8708	264	29	{151,153,150}
8709	264	30	{157}
8710	264	31	{167,168}
8711	264	32	{172}
8712	264	33	{175,174}
8713	265	1	{2}
8714	265	2	{10}
8715	265	3	{12}
8716	265	4	{17}
8717	265	5	{23}
8718	265	6	{27}
8719	265	7	{32}
8720	265	8	{40}
8721	265	9	{42,43,47}
8722	265	10	{52}
8723	265	11	{58}
8724	265	12	{63}
8725	265	13	{68}
8726	265	14	{74}
8727	265	15	{78}
8728	265	16	{83}
8729	265	17	{88}
8730	265	18	{93}
8731	265	19	{99}
8732	265	20	{103}
8733	265	21	{110}
8734	265	22	{112}
8735	265	23	{118}
8736	265	24	{122}
8737	265	25	{128}
8738	265	26	{133,132,135}
8739	265	27	{138}
8740	265	28	{144}
8741	265	29	{148,149}
8742	265	30	{157}
8743	265	31	{163}
8744	265	32	{171}
8745	265	33	{179,180}
8746	266	1	{3}
8747	266	2	{10}
8748	266	3	{11}
8749	266	4	{17}
8750	266	5	{21}
8751	266	6	{27}
8752	266	7	{31}
8753	266	8	{37}
8754	266	9	{42,48,41}
8755	266	10	{54,53}
8756	266	11	{58}
8757	266	12	{63}
8758	266	13	{70}
8759	266	14	{73}
8760	266	15	{77}
8761	266	16	{82}
8762	266	17	{87}
8763	266	18	{93}
8764	266	19	{98}
8765	266	20	{103}
8766	266	21	{109}
8767	266	22	{113}
8768	266	23	{117}
8769	266	24	{122}
8770	266	25	{128}
8771	266	26	{133,136}
8772	266	27	{139}
8773	266	28	{144}
8774	266	29	{151}
8775	266	30	{160}
8776	266	31	{166,164}
8777	266	32	{171}
8778	266	33	{173}
8779	267	1	{2}
8780	267	2	{8}
8781	267	3	{11}
8782	267	4	{17}
8783	267	5	{22}
8784	267	6	{27}
8785	267	7	{31}
8786	267	8	{37}
8787	267	9	{44,45}
8788	267	10	{53}
8789	267	11	{61}
8790	267	12	{63}
8791	267	13	{68}
8792	267	14	{74}
8793	267	15	{78}
8794	267	16	{82}
8795	267	17	{89}
8796	267	18	{93}
8797	267	19	{99}
8798	267	20	{102}
8799	267	21	{108}
8800	267	22	{114}
8801	267	23	{118}
8802	267	24	{123}
8803	267	25	{128}
8804	267	26	{133,132,135}
8805	267	27	{139}
8806	267	28	{143}
8807	267	29	{151,149,154}
8808	267	30	{157}
8809	267	31	{166,169}
8810	267	32	{171}
8811	267	33	{178,180}
8812	268	1	{2}
8813	268	2	{6}
8814	268	3	{11}
8815	268	4	{17}
8816	268	5	{22}
8817	268	6	{27}
8818	268	7	{32}
8819	268	8	{37}
8820	268	9	{42,46,43}
8821	268	10	{53,50,51}
8822	268	11	{58}
8823	268	12	{62}
8824	268	13	{67}
8825	268	14	{72}
8826	268	15	{78}
8827	268	16	{85}
8828	268	17	{88}
8829	268	18	{95}
8830	268	19	{99}
8831	268	20	{103}
8832	268	21	{108}
8833	268	22	{113}
8834	268	23	{118}
8835	268	24	{123}
8836	268	25	{127}
8837	268	26	{133,136}
8838	268	27	{139}
8839	268	28	{145}
8840	268	29	{154,155}
8841	268	30	{159}
8842	268	31	{163}
8843	268	32	{171}
8844	268	33	{175}
8845	269	1	{4}
8846	269	2	{6}
8847	269	3	{13}
8848	269	4	{16}
8849	269	5	{22}
8850	269	6	{26}
8851	269	7	{33}
8852	269	8	{37}
8853	269	9	{41,47}
8854	269	10	{53,56,49}
8855	269	11	{59}
8856	269	12	{63}
8857	269	13	{68}
8858	269	14	{74}
8859	269	15	{78}
8860	269	16	{83}
8861	269	17	{88}
8862	269	18	{93}
8863	269	19	{98}
8864	269	20	{103}
8865	269	21	{109}
8866	269	22	{114}
8867	269	23	{118}
8868	269	24	{123}
8869	269	25	{129}
8870	269	26	{133,132,134}
8871	269	27	{139}
8872	269	28	{143}
8873	269	29	{151,152}
8874	269	30	{156}
8875	269	31	{167,162,164}
8876	269	32	{170}
8877	269	33	{178,176,174}
8878	270	1	{2}
8879	270	2	{8}
8880	270	3	{12}
8881	270	4	{18}
8882	270	5	{21}
8883	270	6	{27}
8884	270	7	{32}
8885	270	8	{38}
8886	270	9	{42,46,41}
8887	270	10	{53,49}
8888	270	11	{58}
8889	270	12	{63}
8890	270	13	{69}
8891	270	14	{73}
8892	270	15	{78}
8893	270	16	{83}
8894	270	17	{88}
8895	270	18	{93}
8896	270	19	{98}
8897	270	20	{103}
8898	270	21	{110}
8899	270	22	{114}
8900	270	23	{121}
8901	270	24	{123}
8902	270	25	{127}
8903	270	26	{133}
8904	270	27	{139}
8905	270	28	{144}
8906	270	29	{153}
8907	270	30	{158}
8908	270	31	{167,161,164}
8909	270	32	{172}
8910	270	33	{180}
8911	271	1	{2}
8912	271	2	{6}
8913	271	3	{11}
8914	271	4	{17}
8915	271	5	{22}
8916	271	6	{30}
8917	271	7	{33}
8918	271	8	{37}
8919	271	9	{42,41,47}
8920	271	10	{50}
8921	271	11	{58}
8922	271	12	{63}
8923	271	13	{69}
8924	271	14	{72}
8925	271	15	{78}
8926	271	16	{83}
8927	271	17	{89}
8928	271	18	{93}
8929	271	19	{100}
8930	271	20	{104}
8931	271	21	{109}
8932	271	22	{112}
8933	271	23	{118}
8934	271	24	{123}
8935	271	25	{128}
8936	271	26	{132,136}
8937	271	27	{140}
8938	271	28	{145}
8939	271	29	{155}
8940	271	30	{156}
8941	271	31	{166,161}
8942	271	32	{171}
8943	271	33	{178,181}
8944	272	1	{3}
8945	272	2	{7}
8946	272	3	{12}
8947	272	4	{17}
8948	272	5	{21}
8949	272	6	{27}
8950	272	7	{33}
8951	272	8	{37}
8952	272	9	{41,47,45}
8953	272	10	{55}
8954	272	11	{59}
8955	272	12	{65}
8956	272	13	{68}
8957	272	14	{73}
8958	272	15	{80}
8959	272	16	{82}
8960	272	17	{88}
8961	272	18	{92}
8962	272	19	{97}
8963	272	20	{103}
8964	272	21	{110}
8965	272	22	{114}
8966	272	23	{118}
8967	272	24	{123}
8968	272	25	{129}
8969	272	26	{133,135}
8970	272	27	{139}
8971	272	28	{147}
8972	272	29	{148,153,150}
8973	272	30	{156}
8974	272	31	{163,161,162}
8975	272	32	{172}
8976	272	33	{180,174}
8977	273	1	{2}
8978	273	2	{7}
8979	273	3	{12}
8980	273	4	{16}
8981	273	5	{25}
8982	273	6	{28}
8983	273	7	{31}
8984	273	8	{37}
8985	273	9	{46,44,41}
8986	273	10	{50}
8987	273	11	{58}
8988	273	12	{63}
8989	273	13	{68}
8990	273	14	{72}
8991	273	15	{77}
8992	273	16	{83}
8993	273	17	{88}
8994	273	18	{93}
8995	273	19	{99}
8996	273	20	{103}
8997	273	21	{109}
8998	273	22	{113}
8999	273	23	{118}
9000	273	24	{123}
9001	273	25	{128}
9002	273	26	{134}
9003	273	27	{138}
9004	273	28	{143}
9005	273	29	{153,152}
9006	273	30	{158}
9007	273	31	{164}
9008	273	32	{172}
9009	273	33	{176,175}
9010	274	1	{2}
9011	274	2	{7}
9012	274	3	{12}
9013	274	4	{17}
9014	274	5	{21}
9015	274	6	{27}
9016	274	7	{32}
9017	274	8	{36}
9018	274	9	{42,47,45}
9019	274	10	{50,56,52}
9020	274	11	{59}
9021	274	12	{65}
9022	274	13	{68}
9023	274	14	{73}
9024	274	15	{78}
9025	274	16	{84}
9026	274	17	{88}
9027	274	18	{93}
9028	274	19	{98}
9029	274	20	{103}
9030	274	21	{109}
9031	274	22	{114}
9032	274	23	{118}
9033	274	24	{123}
9034	274	25	{127}
9035	274	26	{134}
9036	274	27	{138}
9037	274	28	{145}
9038	274	29	{148,149,154}
9039	274	30	{160}
9040	274	31	{168,162,164}
9041	274	32	{172}
9042	274	33	{176}
9043	275	1	{3}
9044	275	2	{9}
9045	275	3	{11}
9046	275	4	{16}
9047	275	5	{22}
9048	275	6	{27}
9049	275	7	{34}
9050	275	8	{37}
9051	275	9	{42,48}
9052	275	10	{50,56,49}
9053	275	11	{58}
9054	275	12	{63}
9055	275	13	{68}
9056	275	14	{74}
9057	275	15	{77}
9058	275	16	{83}
9059	275	17	{88}
9060	275	18	{93}
9061	275	19	{99}
9062	275	20	{103}
9063	275	21	{110}
9064	275	22	{116}
9065	275	23	{118}
9066	275	24	{123}
9067	275	25	{128}
9068	275	26	{134}
9069	275	27	{138}
9070	275	28	{144}
9071	275	29	{151,153,155}
9072	275	30	{160}
9073	275	31	{163,166}
9074	275	32	{171}
9075	275	33	{181,180,173}
9076	276	1	{1}
9077	276	2	{6}
9078	276	3	{12}
9079	276	4	{17}
9080	276	5	{22}
9081	276	6	{27}
9082	276	7	{33}
9083	276	8	{37}
9084	276	9	{48}
9085	276	10	{56}
9086	276	11	{58}
9087	276	12	{63}
9088	276	13	{69}
9089	276	14	{72}
9090	276	15	{78}
9091	276	16	{84}
9092	276	17	{89}
9093	276	18	{93}
9094	276	19	{98}
9095	276	20	{102}
9096	276	21	{109}
9097	276	22	{114}
9098	276	23	{119}
9099	276	24	{123}
9100	276	25	{127}
9101	276	26	{134}
9102	276	27	{139}
9103	276	28	{145}
9104	276	29	{152,149,154}
9105	276	30	{159}
9106	276	31	{163,168,169}
9107	276	32	{172}
9108	276	33	{179,181,177}
9109	277	1	{2}
9110	277	2	{7}
9111	277	3	{12}
9112	277	4	{18}
9113	277	5	{22}
9114	277	6	{27}
9115	277	7	{33}
9116	277	8	{40}
9117	277	9	{41,47}
9118	277	10	{50,51,56}
9119	277	11	{59}
9120	277	12	{62}
9121	277	13	{67}
9122	277	14	{74}
9123	277	15	{78}
9124	277	16	{84}
9125	277	17	{87}
9126	277	18	{94}
9127	277	19	{98}
9128	277	20	{103}
9129	277	21	{109}
9130	277	22	{114}
9131	277	23	{117}
9132	277	24	{123}
9133	277	25	{128}
9134	277	26	{137}
9135	277	27	{140}
9136	277	28	{144}
9137	277	29	{153,154}
9138	277	30	{158}
9139	277	31	{163,162,164}
9140	277	32	{172}
9141	277	33	{178,181}
9142	278	1	{2}
9143	278	2	{7}
9144	278	3	{12}
9145	278	4	{17}
9146	278	5	{21}
9147	278	6	{27}
9148	278	7	{32}
9149	278	8	{37}
9150	278	9	{44}
9151	278	10	{50,56,52}
9152	278	11	{58}
9153	278	12	{64}
9154	278	13	{69}
9155	278	14	{73}
9156	278	15	{79}
9157	278	16	{83}
9158	278	17	{88}
9159	278	18	{93}
9160	278	19	{101}
9161	278	20	{103}
9162	278	21	{109}
9163	278	22	{114}
9164	278	23	{117}
9165	278	24	{123}
9166	278	25	{128}
9167	278	26	{136}
9168	278	27	{140}
9169	278	28	{145}
9170	278	29	{149}
9171	278	30	{156}
9172	278	31	{162}
9173	278	32	{171}
9174	278	33	{179,176,175}
9175	279	1	{4}
9176	279	2	{7}
9177	279	3	{12}
9178	279	4	{17}
9179	279	5	{22}
9180	279	6	{27}
9181	279	7	{32}
9182	279	8	{37}
9183	279	9	{42}
9184	279	10	{50,56}
9185	279	11	{58}
9186	279	12	{63}
9187	279	13	{69}
9188	279	14	{75}
9189	279	15	{78}
9190	279	16	{82}
9191	279	17	{87}
9192	279	18	{93}
9193	279	19	{100}
9194	279	20	{102}
9195	279	21	{109}
9196	279	22	{113}
9197	279	23	{118}
9198	279	24	{123}
9199	279	25	{128}
9200	279	26	{132,135}
9201	279	27	{140}
9202	279	28	{145}
9203	279	29	{151,150}
9204	279	30	{158}
9205	279	31	{162}
9206	279	32	{171}
9207	279	33	{181,173}
9208	280	1	{2}
9209	280	2	{7}
9210	280	3	{12}
9211	280	4	{16}
9212	280	5	{22}
9213	280	6	{26}
9214	280	7	{32}
9215	280	8	{37}
9216	280	9	{46,47}
9217	280	10	{53}
9218	280	11	{57}
9219	280	12	{64}
9220	280	13	{68}
9221	280	14	{73}
9222	280	15	{78}
9223	280	16	{83}
9224	280	17	{88}
9225	280	18	{93}
9226	280	19	{99}
9227	280	20	{106}
9228	280	21	{110}
9229	280	22	{114}
9230	280	23	{117}
9231	280	24	{126}
9232	280	25	{128}
9233	280	26	{135,136,137}
9234	280	27	{139}
9235	280	28	{144}
9236	280	29	{151,150}
9237	280	30	{157}
9238	280	31	{163}
9239	280	32	{171}
9240	280	33	{178,175,174}
9241	281	1	{2}
9242	281	2	{6}
9243	281	3	{12}
9244	281	4	{17}
9245	281	5	{22}
9246	281	6	{27}
9247	281	7	{31}
9248	281	8	{37}
9249	281	9	{48,46}
9250	281	10	{53,49}
9251	281	11	{59}
9252	281	12	{63}
9253	281	13	{68}
9254	281	14	{73}
9255	281	15	{79}
9256	281	16	{83}
9257	281	17	{88}
9258	281	18	{94}
9259	281	19	{97}
9260	281	20	{103}
9261	281	21	{110}
9262	281	22	{113}
9263	281	23	{118}
9264	281	24	{123}
9265	281	25	{128}
9266	281	26	{133}
9267	281	27	{139}
9268	281	28	{143}
9269	281	29	{151,148,149}
9270	281	30	{160}
9271	281	31	{161,165}
9272	281	32	{170}
9273	281	33	{174}
9274	282	1	{2}
9275	282	2	{9}
9276	282	3	{12}
9277	282	4	{16}
9278	282	5	{22}
9279	282	6	{28}
9280	282	7	{32}
9281	282	8	{37}
9282	282	9	{42,48,41}
9283	282	10	{53,51}
9284	282	11	{59}
9285	282	12	{64}
9286	282	13	{69}
9287	282	14	{72}
9288	282	15	{78}
9289	282	16	{82}
9290	282	17	{89}
9291	282	18	{94}
9292	282	19	{98}
9293	282	20	{103}
9294	282	21	{109}
9295	282	22	{113}
9296	282	23	{121}
9297	282	24	{123}
9298	282	25	{128}
9299	282	26	{132,137}
9300	282	27	{139}
9301	282	28	{143}
9302	282	29	{148,150}
9303	282	30	{157}
9304	282	31	{161,165}
9305	282	32	{171}
9306	282	33	{178}
9307	283	1	{2}
9308	283	2	{10}
9309	283	3	{11}
9310	283	4	{16}
9311	283	5	{22}
9312	283	6	{28}
9313	283	7	{31}
9314	283	8	{37}
9315	283	9	{41}
9316	283	10	{53,55}
9317	283	11	{58}
9318	283	12	{63}
9319	283	13	{68}
9320	283	14	{75}
9321	283	15	{79}
9322	283	16	{83}
9323	283	17	{91}
9324	283	18	{93}
9325	283	19	{98}
9326	283	20	{103}
9327	283	21	{110}
9328	283	22	{113}
9329	283	23	{118}
9330	283	24	{124}
9331	283	25	{127}
9332	283	26	{133,132,136}
9333	283	27	{140}
9334	283	28	{144}
9335	283	29	{153,152,155}
9336	283	30	{160}
9337	283	31	{168}
9338	283	32	{171}
9339	283	33	{176,177}
9340	284	1	{3}
9341	284	2	{8}
9342	284	3	{13}
9343	284	4	{17}
9344	284	5	{22}
9345	284	6	{27}
9346	284	7	{32}
9347	284	8	{36}
9348	284	9	{46}
9349	284	10	{51}
9350	284	11	{58}
9351	284	12	{64}
9352	284	13	{68}
9353	284	14	{73}
9354	284	15	{78}
9355	284	16	{83}
9356	284	17	{88}
9357	284	18	{93}
9358	284	19	{98}
9359	284	20	{103}
9360	284	21	{111}
9361	284	22	{114}
9362	284	23	{117}
9363	284	24	{124}
9364	284	25	{127}
9365	284	26	{133}
9366	284	27	{140}
9367	284	28	{144}
9368	284	29	{148,154}
9369	284	30	{159}
9370	284	31	{166}
9371	284	32	{170}
9372	284	33	{176}
9373	285	1	{2}
9374	285	2	{8}
9375	285	3	{12}
9376	285	4	{18}
9377	285	5	{22}
9378	285	6	{26}
9379	285	7	{31}
9380	285	8	{37}
9381	285	9	{44}
9382	285	10	{53,56}
9383	285	11	{58}
9384	285	12	{63}
9385	285	13	{67}
9386	285	14	{73}
9387	285	15	{77}
9388	285	16	{83}
9389	285	17	{89}
9390	285	18	{93}
9391	285	19	{97}
9392	285	20	{102}
9393	285	21	{109}
9394	285	22	{113}
9395	285	23	{118}
9396	285	24	{123}
9397	285	25	{128}
9398	285	26	{132,137}
9399	285	27	{139}
9400	285	28	{144}
9401	285	29	{153,154}
9402	285	30	{160}
9403	285	31	{168,161}
9404	285	32	{171}
9405	285	33	{179,181}
9406	286	1	{2}
9407	286	2	{7}
9408	286	3	{15}
9409	286	4	{17}
9410	286	5	{21}
9411	286	6	{27}
9412	286	7	{32}
9413	286	8	{36}
9414	286	9	{43,47,45}
9415	286	10	{53,52}
9416	286	11	{58}
9417	286	12	{63}
9418	286	13	{67}
9419	286	14	{74}
9420	286	15	{78}
9421	286	16	{82}
9422	286	17	{89}
9423	286	18	{93}
9424	286	19	{99}
9425	286	20	{103}
9426	286	21	{109}
9427	286	22	{113}
9428	286	23	{121}
9429	286	24	{123}
9430	286	25	{128}
9431	286	26	{132,135}
9432	286	27	{139}
9433	286	28	{144}
9434	286	29	{155}
9435	286	30	{156}
9436	286	31	{168,165}
9437	286	32	{172}
9438	286	33	{176}
9439	287	1	{2}
9440	287	2	{7}
9441	287	3	{12}
9442	287	4	{17}
9443	287	5	{23}
9444	287	6	{27}
9445	287	7	{33}
9446	287	8	{36}
9447	287	9	{43,45}
9448	287	10	{50,56}
9449	287	11	{59}
9450	287	12	{63}
9451	287	13	{69}
9452	287	14	{72}
9453	287	15	{79}
9454	287	16	{83}
9455	287	17	{87}
9456	287	18	{94}
9457	287	19	{101}
9458	287	20	{102}
9459	287	21	{109}
9460	287	22	{113}
9461	287	23	{118}
9462	287	24	{124}
9463	287	25	{128}
9464	287	26	{132,135,137}
9465	287	27	{139}
9466	287	28	{143}
9467	287	29	{151,152,154}
9468	287	30	{160}
9469	287	31	{167,161,164}
9470	287	32	{172}
9471	287	33	{176,175}
9472	288	1	{3}
9473	288	2	{7}
9474	288	3	{12}
9475	288	4	{17}
9476	288	5	{21}
9477	288	6	{26}
9478	288	7	{31}
9479	288	8	{36}
9480	288	9	{47}
9481	288	10	{53,55,52}
9482	288	11	{57}
9483	288	12	{62}
9484	288	13	{68}
9485	288	14	{73}
9486	288	15	{78}
9487	288	16	{82}
9488	288	17	{88}
9489	288	18	{94}
9490	288	19	{99}
9491	288	20	{103}
9492	288	21	{109}
9493	288	22	{113}
9494	288	23	{118}
9495	288	24	{123}
9496	288	25	{128}
9497	288	26	{132}
9498	288	27	{138}
9499	288	28	{143}
9500	288	29	{154}
9501	288	30	{158}
9502	288	31	{161,169,164}
9503	288	32	{172}
9504	288	33	{175}
9505	289	1	{2}
9506	289	2	{7}
9507	289	3	{12}
9508	289	4	{17}
9509	289	5	{22}
9510	289	6	{27}
9511	289	7	{32}
9512	289	8	{37}
9513	289	9	{47,45}
9514	289	10	{54,51,52}
9515	289	11	{58}
9516	289	12	{64}
9517	289	13	{68}
9518	289	14	{72}
9519	289	15	{77}
9520	289	16	{82}
9521	289	17	{88}
9522	289	18	{93}
9523	289	19	{97}
9524	289	20	{103}
9525	289	21	{109}
9526	289	22	{113}
9527	289	23	{118}
9528	289	24	{126}
9529	289	25	{128}
9530	289	26	{133}
9531	289	27	{139}
9532	289	28	{144}
9533	289	29	{151}
9534	289	30	{158}
9535	289	31	{163,162}
9536	289	32	{170}
9537	289	33	{176,174}
9538	290	1	{1}
9539	290	2	{7}
9540	290	3	{13}
9541	290	4	{16}
9542	290	5	{24}
9543	290	6	{27}
9544	290	7	{32}
9545	290	8	{37}
9546	290	9	{46,43}
9547	290	10	{55,56}
9548	290	11	{58}
9549	290	12	{63}
9550	290	13	{71}
9551	290	14	{73}
9552	290	15	{78}
9553	290	16	{82}
9554	290	17	{88}
9555	290	18	{96}
9556	290	19	{99}
9557	290	20	{103}
9558	290	21	{109}
9559	290	22	{113}
9560	290	23	{118}
9561	290	24	{123}
9562	290	25	{129}
9563	290	26	{135,134,136}
9564	290	27	{139}
9565	290	28	{144}
9566	290	29	{151,153,155}
9567	290	30	{160}
9568	290	31	{166}
9569	290	32	{170}
9570	290	33	{176,180}
9571	291	1	{2}
9572	291	2	{7}
9573	291	3	{12}
9574	291	4	{17}
9575	291	5	{22}
9576	291	6	{28}
9577	291	7	{32}
9578	291	8	{37}
9579	291	9	{46,43}
9580	291	10	{56,49}
9581	291	11	{58}
9582	291	12	{62}
9583	291	13	{70}
9584	291	14	{73}
9585	291	15	{78}
9586	291	16	{86}
9587	291	17	{87}
9588	291	18	{94}
9589	291	19	{99}
9590	291	20	{103}
9591	291	21	{110}
9592	291	22	{114}
9593	291	23	{117}
9594	291	24	{123}
9595	291	25	{128}
9596	291	26	{132,134,136}
9597	291	27	{139}
9598	291	28	{144}
9599	291	29	{151,148,149}
9600	291	30	{160}
9601	291	31	{163,165,164}
9602	291	32	{170}
9603	291	33	{174,177}
9604	292	1	{2}
9605	292	2	{7}
9606	292	3	{11}
9607	292	4	{16}
9608	292	5	{22}
9609	292	6	{27}
9610	292	7	{32}
9611	292	8	{37}
9612	292	9	{41}
9613	292	10	{53,52}
9614	292	11	{58}
9615	292	12	{62}
9616	292	13	{70}
9617	292	14	{73}
9618	292	15	{79}
9619	292	16	{83}
9620	292	17	{88}
9621	292	18	{92}
9622	292	19	{98}
9623	292	20	{103}
9624	292	21	{110}
9625	292	22	{113}
9626	292	23	{118}
9627	292	24	{123}
9628	292	25	{128}
9629	292	26	{134,136,137}
9630	292	27	{139}
9631	292	28	{143}
9632	292	29	{151,153,150}
9633	292	30	{160}
9634	292	31	{163,162}
9635	292	32	{171}
9636	292	33	{179,181}
9637	293	1	{2}
9638	293	2	{8}
9639	293	3	{13}
9640	293	4	{18}
9641	293	5	{23}
9642	293	6	{27}
9643	293	7	{32}
9644	293	8	{38}
9645	293	9	{48,45}
9646	293	10	{51,49}
9647	293	11	{58}
9648	293	12	{62}
9649	293	13	{68}
9650	293	14	{72}
9651	293	15	{78}
9652	293	16	{83}
9653	293	17	{87}
9654	293	18	{93}
9655	293	19	{99}
9656	293	20	{104}
9657	293	21	{110}
9658	293	22	{115}
9659	293	23	{118}
9660	293	24	{122}
9661	293	25	{128}
9662	293	26	{136}
9663	293	27	{139}
9664	293	28	{144}
9665	293	29	{150,149}
9666	293	30	{156}
9667	293	31	{167}
9668	293	32	{170}
9669	293	33	{177}
9670	294	1	{2}
9671	294	2	{6}
9672	294	3	{11}
9673	294	4	{17}
9674	294	5	{22}
9675	294	6	{29}
9676	294	7	{32}
9677	294	8	{37}
9678	294	9	{48,46}
9679	294	10	{50}
9680	294	11	{59}
9681	294	12	{62}
9682	294	13	{68}
9683	294	14	{73}
9684	294	15	{77}
9685	294	16	{83}
9686	294	17	{89}
9687	294	18	{94}
9688	294	19	{98}
9689	294	20	{104}
9690	294	21	{109}
9691	294	22	{112}
9692	294	23	{118}
9693	294	24	{123}
9694	294	25	{128}
9695	294	26	{132,137}
9696	294	27	{140}
9697	294	28	{145}
9698	294	29	{151,153,150}
9699	294	30	{160}
9700	294	31	{168,161,164}
9701	294	32	{171}
9702	294	33	{173}
9703	295	1	{2}
9704	295	2	{6}
9705	295	3	{12}
9706	295	4	{16}
9707	295	5	{22}
9708	295	6	{26}
9709	295	7	{32}
9710	295	8	{37}
9711	295	9	{48,43}
9712	295	10	{51}
9713	295	11	{58}
9714	295	12	{64}
9715	295	13	{67}
9716	295	14	{73}
9717	295	15	{78}
9718	295	16	{83}
9719	295	17	{88}
9720	295	18	{93}
9721	295	19	{99}
9722	295	20	{104}
9723	295	21	{109}
9724	295	22	{115}
9725	295	23	{118}
9726	295	24	{125}
9727	295	25	{128}
9728	295	26	{134}
9729	295	27	{139}
9730	295	28	{143}
9731	295	29	{152,150}
9732	295	30	{156}
9733	295	31	{163,167}
9734	295	32	{172}
9735	295	33	{174,173}
9736	296	1	{2}
9737	296	2	{7}
9738	296	3	{12}
9739	296	4	{17}
9740	296	5	{21}
9741	296	6	{28}
9742	296	7	{32}
9743	296	8	{37}
9744	296	9	{42,47}
9745	296	10	{51,56}
9746	296	11	{61}
9747	296	12	{62}
9748	296	13	{67}
9749	296	14	{72}
9750	296	15	{78}
9751	296	16	{82}
9752	296	17	{88}
9753	296	18	{96}
9754	296	19	{99}
9755	296	20	{104}
9756	296	21	{109}
9757	296	22	{113}
9758	296	23	{118}
9759	296	24	{122}
9760	296	25	{130}
9761	296	26	{137}
9762	296	27	{139}
9763	296	28	{143}
9764	296	29	{152}
9765	296	30	{160}
9766	296	31	{165}
9767	296	32	{171}
9768	296	33	{178,174}
9769	297	1	{1}
9770	297	2	{7}
9771	297	3	{12}
9772	297	4	{18}
9773	297	5	{23}
9774	297	6	{30}
9775	297	7	{32}
9776	297	8	{39}
9777	297	9	{41,47,45}
9778	297	10	{54,53,49}
9779	297	11	{57}
9780	297	12	{63}
9781	297	13	{70}
9782	297	14	{73}
9783	297	15	{79}
9784	297	16	{83}
9785	297	17	{88}
9786	297	18	{94}
9787	297	19	{98}
9788	297	20	{104}
9789	297	21	{110}
9790	297	22	{113}
9791	297	23	{118}
9792	297	24	{126}
9793	297	25	{128}
9794	297	26	{135}
9795	297	27	{142}
9796	297	28	{144}
9797	297	29	{148,150}
9798	297	30	{160}
9799	297	31	{163,167,164}
9800	297	32	{171}
9801	297	33	{179,174,173}
9802	298	1	{4}
9803	298	2	{6}
9804	298	3	{13}
9805	298	4	{18}
9806	298	5	{22}
9807	298	6	{26}
9808	298	7	{32}
9809	298	8	{37}
9810	298	9	{48,41}
9811	298	10	{54,56,52}
9812	298	11	{59}
9813	298	12	{63}
9814	298	13	{68}
9815	298	14	{73}
9816	298	15	{78}
9817	298	16	{86}
9818	298	17	{89}
9819	298	18	{94}
9820	298	19	{98}
9821	298	20	{103}
9822	298	21	{109}
9823	298	22	{113}
9824	298	23	{117}
9825	298	24	{124}
9826	298	25	{128}
9827	298	26	{132,134}
9828	298	27	{138}
9829	298	28	{144}
9830	298	29	{153,152,155}
9831	298	30	{156}
9832	298	31	{166,168}
9833	298	32	{170}
9834	298	33	{175}
9835	299	1	{2}
9836	299	2	{7}
9837	299	3	{12}
9838	299	4	{17}
9839	299	5	{22}
9840	299	6	{28}
9841	299	7	{32}
9842	299	8	{37}
9843	299	9	{45}
9844	299	10	{51,52}
9845	299	11	{58}
9846	299	12	{64}
9847	299	13	{68}
9848	299	14	{73}
9849	299	15	{78}
9850	299	16	{83}
9851	299	17	{88}
9852	299	18	{92}
9853	299	19	{98}
9854	299	20	{102}
9855	299	21	{109}
9856	299	22	{114}
9857	299	23	{117}
9858	299	24	{124}
9859	299	25	{128}
9860	299	26	{132,134}
9861	299	27	{139}
9862	299	28	{145}
9863	299	29	{148,153}
9864	299	30	{158}
9865	299	31	{165}
9866	299	32	{172}
9867	299	33	{176}
9868	300	1	{2}
9869	300	2	{7}
9870	300	3	{12}
9871	300	4	{20}
9872	300	5	{22}
9873	300	6	{27}
9874	300	7	{33}
9875	300	8	{38}
9876	300	9	{41}
9877	300	10	{50,52}
9878	300	11	{58}
9879	300	12	{63}
9880	300	13	{68}
9881	300	14	{73}
9882	300	15	{81}
9883	300	16	{83}
9884	300	17	{88}
9885	300	18	{93}
9886	300	19	{98}
9887	300	20	{104}
9888	300	21	{109}
9889	300	22	{113}
9890	300	23	{118}
9891	300	24	{122}
9892	300	25	{128}
9893	300	26	{133,135,134}
9894	300	27	{139}
9895	300	28	{144}
9896	300	29	{152}
9897	300	30	{158}
9898	300	31	{166,162}
9899	300	32	{170}
9900	300	33	{181,177,173}
9901	301	1	{2}
9902	301	2	{8}
9903	301	3	{13}
9904	301	4	{18}
9905	301	5	{23}
9906	301	6	{28}
9907	301	7	{32}
9908	301	8	{40}
9909	301	9	{42,46}
9910	301	10	{51,56,52}
9911	301	11	{61}
9912	301	12	{64}
9913	301	13	{70}
9914	301	14	{74}
9915	301	15	{80}
9916	301	16	{84}
9917	301	17	{89}
9918	301	18	{94}
9919	301	19	{99}
9920	301	20	{104}
9921	301	21	{110}
9922	301	22	{114}
9923	301	23	{118}
9924	301	24	{124}
9925	301	25	{130}
9926	301	26	{132,134}
9927	301	27	{140}
9928	301	28	{145}
9929	301	29	{151,148,150}
9930	301	30	{157}
9931	301	31	{169}
9932	301	32	{171}
9933	301	33	{178,173}
9934	302	1	{3}
9935	302	2	{8}
9936	302	3	{11}
9937	302	4	{19}
9938	302	5	{23}
9939	302	6	{28}
9940	302	7	{33}
9941	302	8	{38}
9942	302	9	{44,45}
9943	302	10	{51,55,49}
9944	302	11	{59}
9945	302	12	{64}
9946	302	13	{70}
9947	302	14	{74}
9948	302	15	{79}
9949	302	16	{85}
9950	302	17	{89}
9951	302	18	{93}
9952	302	19	{99}
9953	302	20	{102}
9954	302	21	{110}
9955	302	22	{115}
9956	302	23	{119}
9957	302	24	{124}
9958	302	25	{129}
9959	302	26	{134,137}
9960	302	27	{140}
9961	302	28	{146}
9962	302	29	{151,149}
9963	302	30	{157}
9964	302	31	{167,165}
9965	302	32	{170}
9966	302	33	{181}
9967	303	1	{2}
9968	303	2	{8}
9969	303	3	{13}
9970	303	4	{18}
9971	303	5	{23}
9972	303	6	{28}
9973	303	7	{34}
9974	303	8	{38}
9975	303	9	{42}
9976	303	10	{55,49}
9977	303	11	{61}
9978	303	12	{65}
9979	303	13	{69}
9980	303	14	{74}
9981	303	15	{79}
9982	303	16	{84}
9983	303	17	{89}
9984	303	18	{94}
9985	303	19	{100}
9986	303	20	{103}
9987	303	21	{110}
9988	303	22	{114}
9989	303	23	{121}
9990	303	24	{125}
9991	303	25	{129}
9992	303	26	{133}
9993	303	27	{140}
9994	303	28	{146}
9995	303	29	{153}
9996	303	30	{160}
9997	303	31	{167,161,165}
9998	303	32	{171}
9999	303	33	{179,175}
10000	304	1	{3}
10001	304	2	{9}
10002	304	3	{13}
10003	304	4	{18}
10004	304	5	{23}
10005	304	6	{28}
10006	304	7	{32}
10007	304	8	{38}
10008	304	9	{46}
10009	304	10	{56,49}
10010	304	11	{59}
10011	304	12	{65}
10012	304	13	{70}
10013	304	14	{76}
10014	304	15	{79}
10015	304	16	{83}
10016	304	17	{89}
10017	304	18	{92}
10018	304	19	{99}
10019	304	20	{103}
10020	304	21	{110}
10021	304	22	{113}
10022	304	23	{119}
10023	304	24	{124}
10024	304	25	{129}
10025	304	26	{133}
10026	304	27	{140}
10027	304	28	{145}
10028	304	29	{151,150}
10029	304	30	{157}
10030	304	31	{165,169}
10031	304	32	{170}
10032	304	33	{175,174}
10033	305	1	{4}
10034	305	2	{8}
10035	305	3	{12}
10036	305	4	{18}
10037	305	5	{23}
10038	305	6	{30}
10039	305	7	{33}
10040	305	8	{38}
10041	305	9	{46,47}
10042	305	10	{53}
10043	305	11	{59}
10044	305	12	{64}
10045	305	13	{69}
10046	305	14	{74}
10047	305	15	{79}
10048	305	16	{83}
10049	305	17	{89}
10050	305	18	{93}
10051	305	19	{99}
10052	305	20	{106}
10053	305	21	{110}
10054	305	22	{115}
10055	305	23	{119}
10056	305	24	{125}
10057	305	25	{129}
10058	305	26	{133,136,137}
10059	305	27	{140}
10060	305	28	{146}
10061	305	29	{151,152,149}
10062	305	30	{158}
10063	305	31	{163,167,162}
10064	305	32	{172}
10065	305	33	{180,177,173}
10066	306	1	{3}
10067	306	2	{8}
10068	306	3	{13}
10069	306	4	{18}
10070	306	5	{23}
10071	306	6	{29}
10072	306	7	{33}
10073	306	8	{37}
10074	306	9	{43}
10075	306	10	{54,51,52}
10076	306	11	{58}
10077	306	12	{64}
10078	306	13	{69}
10079	306	14	{72}
10080	306	15	{79}
10081	306	16	{83}
10082	306	17	{89}
10083	306	18	{94}
10084	306	19	{99}
10085	306	20	{104}
10086	306	21	{110}
10087	306	22	{114}
10088	306	23	{118}
10089	306	24	{124}
10090	306	25	{128}
10091	306	26	{132,134,137}
10092	306	27	{140}
10093	306	28	{145}
10094	306	29	{151}
10095	306	30	{158}
10096	306	31	{165,164}
10097	306	32	{172}
10098	306	33	{179,180,174}
10099	307	1	{3}
10100	307	2	{9}
10101	307	3	{12}
10102	307	4	{16}
10103	307	5	{22}
10104	307	6	{27}
10105	307	7	{33}
10106	307	8	{36}
10107	307	9	{44,43,45}
10108	307	10	{52}
10109	307	11	{59}
10110	307	12	{64}
10111	307	13	{70}
10112	307	14	{74}
10113	307	15	{80}
10114	307	16	{84}
10115	307	17	{89}
10116	307	18	{95}
10117	307	19	{101}
10118	307	20	{104}
10119	307	21	{110}
10120	307	22	{115}
10121	307	23	{120}
10122	307	24	{123}
10123	307	25	{130}
10124	307	26	{132,137}
10125	307	27	{140}
10126	307	28	{145}
10127	307	29	{148}
10128	307	30	{158}
10129	307	31	{163,168,165}
10130	307	32	{171}
10131	307	33	{175}
10132	308	1	{3}
10133	308	2	{10}
10134	308	3	{13}
10135	308	4	{18}
10136	308	5	{23}
10137	308	6	{28}
10138	308	7	{33}
10139	308	8	{38}
10140	308	9	{46,44,43}
10141	308	10	{50,56}
10142	308	11	{60}
10143	308	12	{65}
10144	308	13	{69}
10145	308	14	{74}
10146	308	15	{79}
10147	308	16	{85}
10148	308	17	{89}
10149	308	18	{95}
10150	308	19	{99}
10151	308	20	{104}
10152	308	21	{110}
10153	308	22	{113}
10154	308	23	{119}
10155	308	24	{124}
10156	308	25	{129}
10157	308	26	{132,136}
10158	308	27	{139}
10159	308	28	{144}
10160	308	29	{150,149}
10161	308	30	{156}
10162	308	31	{167,161,169}
10163	308	32	{171}
10164	308	33	{181}
10165	309	1	{2}
10166	309	2	{9}
10167	309	3	{11}
10168	309	4	{18}
10169	309	5	{23}
10170	309	6	{27}
10171	309	7	{33}
10172	309	8	{39}
10173	309	9	{46,44,41}
10174	309	10	{55,56,49}
10175	309	11	{59}
10176	309	12	{65}
10177	309	13	{69}
10178	309	14	{74}
10179	309	15	{79}
10180	309	16	{83}
10181	309	17	{89}
10182	309	18	{96}
10183	309	19	{99}
10184	309	20	{104}
10185	309	21	{110}
10186	309	22	{114}
10187	309	23	{118}
10188	309	24	{125}
10189	309	25	{128}
10190	309	26	{133,134}
10191	309	27	{141}
10192	309	28	{145}
10193	309	29	{151,153,155}
10194	309	30	{157}
10195	309	31	{161,162}
10196	309	32	{171}
10197	309	33	{177}
10198	310	1	{3}
10199	310	2	{8}
10200	310	3	{13}
10201	310	4	{18}
10202	310	5	{23}
10203	310	6	{29}
10204	310	7	{33}
10205	310	8	{38}
10206	310	9	{48,45}
10207	310	10	{56}
10208	310	11	{58}
10209	310	12	{64}
10210	310	13	{70}
10211	310	14	{74}
10212	310	15	{78}
10213	310	16	{84}
10214	310	17	{89}
10215	310	18	{94}
10216	310	19	{98}
10217	310	20	{104}
10218	310	21	{110}
10219	310	22	{114}
10220	310	23	{120}
10221	310	24	{123}
10222	310	25	{129}
10223	310	26	{133,136,137}
10224	310	27	{140}
10225	310	28	{145}
10226	310	29	{151,150}
10227	310	30	{159}
10228	310	31	{169}
10229	310	32	{171}
10230	310	33	{181,177}
10231	311	1	{3}
10232	311	2	{8}
10233	311	3	{13}
10234	311	4	{18}
10235	311	5	{23}
10236	311	6	{29}
10237	311	7	{33}
10238	311	8	{38}
10239	311	9	{46,41,47}
10240	311	10	{55,49}
10241	311	11	{58}
10242	311	12	{64}
10243	311	13	{69}
10244	311	14	{74}
10245	311	15	{79}
10246	311	16	{84}
10247	311	17	{88}
10248	311	18	{94}
10249	311	19	{99}
10250	311	20	{105}
10251	311	21	{110}
10252	311	22	{114}
10253	311	23	{119}
10254	311	24	{122}
10255	311	25	{129}
10256	311	26	{133,132,134}
10257	311	27	{140}
10258	311	28	{145}
10259	311	29	{151}
10260	311	30	{158}
10261	311	31	{166,165,169}
10262	311	32	{171}
10263	311	33	{178,180,177}
10264	312	1	{2}
10265	312	2	{8}
10266	312	3	{13}
10267	312	4	{18}
10268	312	5	{22}
10269	312	6	{27}
10270	312	7	{32}
10271	312	8	{39}
10272	312	9	{48,46}
10273	312	10	{51,55,49}
10274	312	11	{60}
10275	312	12	{64}
10276	312	13	{69}
10277	312	14	{73}
10278	312	15	{80}
10279	312	16	{83}
10280	312	17	{89}
10281	312	18	{95}
10282	312	19	{99}
10283	312	20	{103}
10284	312	21	{110}
10285	312	22	{114}
10286	312	23	{118}
10287	312	24	{124}
10288	312	25	{130}
10289	312	26	{132}
10290	312	27	{139}
10291	312	28	{144}
10292	312	29	{151,150}
10293	312	30	{156}
10294	312	31	{164}
10295	312	32	{172}
10296	312	33	{177}
10297	313	1	{2}
10298	313	2	{8}
10299	313	3	{12}
10300	313	4	{18}
10301	313	5	{23}
10302	313	6	{29}
10303	313	7	{32}
10304	313	8	{38}
10305	313	9	{46,41}
10306	313	10	{53,55}
10307	313	11	{60}
10308	313	12	{62}
10309	313	13	{70}
10310	313	14	{74}
10311	313	15	{79}
10312	313	16	{84}
10313	313	17	{89}
10314	313	18	{94}
10315	313	19	{99}
10316	313	20	{105}
10317	313	21	{109}
10318	313	22	{114}
10319	313	23	{118}
10320	313	24	{123}
10321	313	25	{129}
10322	313	26	{133,136,137}
10323	313	27	{140}
10324	313	28	{145}
10325	313	29	{151,154}
10326	313	30	{158}
10327	313	31	{166,161,162}
10328	313	32	{170}
10329	313	33	{180,173}
10330	314	1	{4}
10331	314	2	{10}
10332	314	3	{14}
10333	314	4	{17}
10334	314	5	{23}
10335	314	6	{28}
10336	314	7	{33}
10337	314	8	{37}
10338	314	9	{47,45}
10339	314	10	{55}
10340	314	11	{59}
10341	314	12	{64}
10342	314	13	{69}
10343	314	14	{74}
10344	314	15	{78}
10345	314	16	{84}
10346	314	17	{89}
10347	314	18	{95}
10348	314	19	{98}
10349	314	20	{102}
10350	314	21	{109}
10351	314	22	{115}
10352	314	23	{119}
10353	314	24	{124}
10354	314	25	{128}
10355	314	26	{136}
10356	314	27	{140}
10357	314	28	{144}
10358	314	29	{149,154}
10359	314	30	{159}
10360	314	31	{166,161,162}
10361	314	32	{171}
10362	314	33	{178,181,173}
10363	315	1	{3}
10364	315	2	{7}
10365	315	3	{13}
10366	315	4	{18}
10367	315	5	{22}
10368	315	6	{29}
10369	315	7	{33}
10370	315	8	{36}
10371	315	9	{47}
10372	315	10	{54,51,55}
10373	315	11	{60}
10374	315	12	{64}
10375	315	13	{69}
10376	315	14	{74}
10377	315	15	{80}
10378	315	16	{86}
10379	315	17	{89}
10380	315	18	{94}
10381	315	19	{99}
10382	315	20	{104}
10383	315	21	{110}
10384	315	22	{114}
10385	315	23	{119}
10386	315	24	{124}
10387	315	25	{130}
10388	315	26	{136,137}
10389	315	27	{142}
10390	315	28	{145}
10391	315	29	{150}
10392	315	30	{157}
10393	315	31	{163,161}
10394	315	32	{170}
10395	315	33	{181,175,174}
10396	316	1	{3}
10397	316	2	{8}
10398	316	3	{12}
10399	316	4	{18}
10400	316	5	{23}
10401	316	6	{28}
10402	316	7	{32}
10403	316	8	{39}
10404	316	9	{44,45}
10405	316	10	{54}
10406	316	11	{58}
10407	316	12	{64}
10408	316	13	{68}
10409	316	14	{74}
10410	316	15	{78}
10411	316	16	{85}
10412	316	17	{89}
10413	316	18	{95}
10414	316	19	{100}
10415	316	20	{104}
10416	316	21	{110}
10417	316	22	{115}
10418	316	23	{120}
10419	316	24	{124}
10420	316	25	{127}
10421	316	26	{135}
10422	316	27	{141}
10423	316	28	{145}
10424	316	29	{148,153,155}
10425	316	30	{160}
10426	316	31	{168,169,164}
10427	316	32	{171}
10428	316	33	{178,175}
10429	317	1	{3}
10430	317	2	{9}
10431	317	3	{13}
10432	317	4	{18}
10433	317	5	{23}
10434	317	6	{28}
10435	317	7	{34}
10436	317	8	{38}
10437	317	9	{46}
10438	317	10	{51,55,56}
10439	317	11	{60}
10440	317	12	{64}
10441	317	13	{68}
10442	317	14	{76}
10443	317	15	{79}
10444	317	16	{85}
10445	317	17	{89}
10446	317	18	{94}
10447	317	19	{101}
10448	317	20	{104}
10449	317	21	{110}
10450	317	22	{113}
10451	317	23	{119}
10452	317	24	{124}
10453	317	25	{128}
10454	317	26	{133,135}
10455	317	27	{141}
10456	317	28	{146}
10457	317	29	{152,150,154}
10458	317	30	{160}
10459	317	31	{164}
10460	317	32	{171}
10461	317	33	{179,174}
10462	318	1	{3}
10463	318	2	{10}
10464	318	3	{13}
10465	318	4	{18}
10466	318	5	{23}
10467	318	6	{28}
10468	318	7	{33}
10469	318	8	{38}
10470	318	9	{46,41}
10471	318	10	{49}
10472	318	11	{57}
10473	318	12	{64}
10474	318	13	{69}
10475	318	14	{74}
10476	318	15	{80}
10477	318	16	{84}
10478	318	17	{88}
10479	318	18	{92}
10480	318	19	{100}
10481	318	20	{104}
10482	318	21	{111}
10483	318	22	{114}
10484	318	23	{119}
10485	318	24	{124}
10486	318	25	{128}
10487	318	26	{132,135}
10488	318	27	{140}
10489	318	28	{145}
10490	318	29	{155}
10491	318	30	{159}
10492	318	31	{161,169,164}
10493	318	32	{172}
10494	318	33	{175}
10495	319	1	{3}
10496	319	2	{8}
10497	319	3	{14}
10498	319	4	{18}
10499	319	5	{23}
10500	319	6	{28}
10501	319	7	{33}
10502	319	8	{39}
10503	319	9	{46,41,47}
10504	319	10	{49}
10505	319	11	{59}
10506	319	12	{62}
10507	319	13	{69}
10508	319	14	{73}
10509	319	15	{80}
10510	319	16	{84}
10511	319	17	{89}
10512	319	18	{96}
10513	319	19	{99}
10514	319	20	{104}
10515	319	21	{110}
10516	319	22	{114}
10517	319	23	{119}
10518	319	24	{124}
10519	319	25	{130}
10520	319	26	{133}
10521	319	27	{139}
10522	319	28	{145}
10523	319	29	{152,150}
10524	319	30	{159}
10525	319	31	{168,162,164}
10526	319	32	{170}
10527	319	33	{179,180,174}
10528	320	1	{3}
10529	320	2	{7}
10530	320	3	{12}
10531	320	4	{17}
10532	320	5	{23}
10533	320	6	{28}
10534	320	7	{33}
10535	320	8	{38}
10536	320	9	{42,44}
10537	320	10	{53,50,55}
10538	320	11	{59}
10539	320	12	{65}
10540	320	13	{69}
10541	320	14	{74}
10542	320	15	{79}
10543	320	16	{86}
10544	320	17	{90}
10545	320	18	{94}
10546	320	19	{99}
10547	320	20	{104}
10548	320	21	{110}
10549	320	22	{113}
10550	320	23	{119}
10551	320	24	{124}
10552	320	25	{129}
10553	320	26	{133,132,134}
10554	320	27	{140}
10555	320	28	{145}
10556	320	29	{152,150,155}
10557	320	30	{158}
10558	320	31	{161,165}
10559	320	32	{172}
10560	320	33	{178,177}
10561	321	1	{2}
10562	321	2	{8}
10563	321	3	{14}
10564	321	4	{18}
10565	321	5	{24}
10566	321	6	{29}
10567	321	7	{33}
10568	321	8	{38}
10569	321	9	{42,44,43}
10570	321	10	{51,55,52}
10571	321	11	{60}
10572	321	12	{64}
10573	321	13	{69}
10574	321	14	{73}
10575	321	15	{79}
10576	321	16	{83}
10577	321	17	{89}
10578	321	18	{94}
10579	321	19	{99}
10580	321	20	{104}
10581	321	21	{108}
10582	321	22	{113}
10583	321	23	{120}
10584	321	24	{124}
10585	321	25	{130}
10586	321	26	{134}
10587	321	27	{140}
10588	321	28	{145}
10589	321	29	{151}
10590	321	30	{157}
10591	321	31	{162}
10592	321	32	{172}
10593	321	33	{178}
10594	322	1	{3}
10595	322	2	{9}
10596	322	3	{13}
10597	322	4	{18}
10598	322	5	{23}
10599	322	6	{28}
10600	322	7	{33}
10601	322	8	{39}
10602	322	9	{48,44,45}
10603	322	10	{51}
10604	322	11	{59}
10605	322	12	{65}
10606	322	13	{69}
10607	322	14	{74}
10608	322	15	{78}
10609	322	16	{82}
10610	322	17	{89}
10611	322	18	{94}
10612	322	19	{98}
10613	322	20	{104}
10614	322	21	{110}
10615	322	22	{114}
10616	322	23	{120}
10617	322	24	{124}
10618	322	25	{127}
10619	322	26	{132,135,136}
10620	322	27	{140}
10621	322	28	{145}
10622	322	29	{151,148}
10623	322	30	{157}
10624	322	31	{164}
10625	322	32	{172}
10626	322	33	{179,175}
10627	323	1	{5}
10628	323	2	{9}
10629	323	3	{13}
10630	323	4	{17}
10631	323	5	{23}
10632	323	6	{28}
10633	323	7	{32}
10634	323	8	{39}
10635	323	9	{48,46,44}
10636	323	10	{54}
10637	323	11	{60}
10638	323	12	{64}
10639	323	13	{70}
10640	323	14	{74}
10641	323	15	{79}
10642	323	16	{84}
10643	323	17	{88}
10644	323	18	{95}
10645	323	19	{100}
10646	323	20	{105}
10647	323	21	{110}
10648	323	22	{116}
10649	323	23	{119}
10650	323	24	{124}
10651	323	25	{128}
10652	323	26	{135,134}
10653	323	27	{139}
10654	323	28	{145}
10655	323	29	{153,154}
10656	323	30	{158}
10657	323	31	{169}
10658	323	32	{170}
10659	323	33	{181}
10660	324	1	{2}
10661	324	2	{8}
10662	324	3	{13}
10663	324	4	{18}
10664	324	5	{23}
10665	324	6	{28}
10666	324	7	{33}
10667	324	8	{38}
10668	324	9	{43}
10669	324	10	{51,55}
10670	324	11	{59}
10671	324	12	{64}
10672	324	13	{69}
10673	324	14	{73}
10674	324	15	{78}
10675	324	16	{84}
10676	324	17	{89}
10677	324	18	{94}
10678	324	19	{98}
10679	324	20	{103}
10680	324	21	{111}
10681	324	22	{115}
10682	324	23	{119}
10683	324	24	{124}
10684	324	25	{129}
10685	324	26	{135,136,137}
10686	324	27	{141}
10687	324	28	{144}
10688	324	29	{151,154}
10689	324	30	{159}
10690	324	31	{162,165}
10691	324	32	{172}
10692	324	33	{178,179}
10693	325	1	{2}
10694	325	2	{8}
10695	325	3	{14}
10696	325	4	{17}
10697	325	5	{23}
10698	325	6	{29}
10699	325	7	{32}
10700	325	8	{38}
10701	325	9	{44}
10702	325	10	{54,50,52}
10703	325	11	{58}
10704	325	12	{65}
10705	325	13	{69}
10706	325	14	{74}
10707	325	15	{80}
10708	325	16	{83}
10709	325	17	{89}
10710	325	18	{94}
10711	325	19	{99}
10712	325	20	{104}
10713	325	21	{109}
10714	325	22	{114}
10715	325	23	{120}
10716	325	24	{124}
10717	325	25	{130}
10718	325	26	{133,132,136}
10719	325	27	{139}
10720	325	28	{147}
10721	325	29	{148,150}
10722	325	30	{160}
10723	325	31	{167,162,164}
10724	325	32	{170}
10725	325	33	{177,173}
10726	326	1	{3}
10727	326	2	{8}
10728	326	3	{12}
10729	326	4	{18}
10730	326	5	{22}
10731	326	6	{28}
10732	326	7	{34}
10733	326	8	{38}
10734	326	9	{47}
10735	326	10	{51}
10736	326	11	{60}
10737	326	12	{66}
10738	326	13	{69}
10739	326	14	{74}
10740	326	15	{79}
10741	326	16	{84}
10742	326	17	{89}
10743	326	18	{94}
10744	326	19	{99}
10745	326	20	{104}
10746	326	21	{111}
10747	326	22	{116}
10748	326	23	{120}
10749	326	24	{124}
10750	326	25	{129}
10751	326	26	{133,132}
10752	326	27	{141}
10753	326	28	{145}
10754	326	29	{149,155}
10755	326	30	{158}
10756	326	31	{167,161}
10757	326	32	{172}
10758	326	33	{173}
10759	327	1	{4}
10760	327	2	{8}
10761	327	3	{12}
10762	327	4	{18}
10763	327	5	{23}
10764	327	6	{27}
10765	327	7	{33}
10766	327	8	{38}
10767	327	9	{48,46,41}
10768	327	10	{51,52}
10769	327	11	{59}
10770	327	12	{64}
10771	327	13	{70}
10772	327	14	{74}
10773	327	15	{79}
10774	327	16	{85}
10775	327	17	{88}
10776	327	18	{96}
10777	327	19	{100}
10778	327	20	{105}
10779	327	21	{111}
10780	327	22	{114}
10781	327	23	{119}
10782	327	24	{124}
10783	327	25	{129}
10784	327	26	{133,135,136}
10785	327	27	{140}
10786	327	28	{144}
10787	327	29	{155}
10788	327	30	{158}
10789	327	31	{163,167}
10790	327	32	{171}
10791	327	33	{179,177,173}
10792	328	1	{4}
10793	328	2	{8}
10794	328	3	{13}
10795	328	4	{17}
10796	328	5	{22}
10797	328	6	{28}
10798	328	7	{33}
10799	328	8	{38}
10800	328	9	{44,41}
10801	328	10	{56,49}
10802	328	11	{59}
10803	328	12	{63}
10804	328	13	{69}
10805	328	14	{74}
10806	328	15	{79}
10807	328	16	{84}
10808	328	17	{89}
10809	328	18	{95}
10810	328	19	{99}
10811	328	20	{104}
10812	328	21	{110}
10813	328	22	{114}
10814	328	23	{120}
10815	328	24	{124}
10816	328	25	{129}
10817	328	26	{133,137}
10818	328	27	{140}
10819	328	28	{145}
10820	328	29	{151}
10821	328	30	{159}
10822	328	31	{167,166,164}
10823	328	32	{171}
10824	328	33	{179,177}
10825	329	1	{2}
10826	329	2	{8}
10827	329	3	{12}
10828	329	4	{19}
10829	329	5	{23}
10830	329	6	{27}
10831	329	7	{34}
10832	329	8	{38}
10833	329	9	{42,41,47}
10834	329	10	{53,50,56}
10835	329	11	{59}
10836	329	12	{63}
10837	329	13	{69}
10838	329	14	{73}
10839	329	15	{80}
10840	329	16	{85}
10841	329	17	{89}
10842	329	18	{94}
10843	329	19	{99}
10844	329	20	{103}
10845	329	21	{111}
10846	329	22	{114}
10847	329	23	{119}
10848	329	24	{124}
10849	329	25	{129}
10850	329	26	{133,134}
10851	329	27	{140}
10852	329	28	{146}
10853	329	29	{151}
10854	329	30	{157}
10855	329	31	{163,161}
10856	329	32	{171}
10857	329	33	{178,175,173}
10858	330	1	{4}
10859	330	2	{8}
10860	330	3	{13}
10861	330	4	{18}
10862	330	5	{23}
10863	330	6	{28}
10864	330	7	{33}
10865	330	8	{37}
10866	330	9	{45}
10867	330	10	{54}
10868	330	11	{58}
10869	330	12	{63}
10870	330	13	{69}
10871	330	14	{74}
10872	330	15	{79}
10873	330	16	{83}
10874	330	17	{89}
10875	330	18	{94}
10876	330	19	{99}
10877	330	20	{104}
10878	330	21	{108}
10879	330	22	{113}
10880	330	23	{119}
10881	330	24	{124}
10882	330	25	{129}
10883	330	26	{132,134}
10884	330	27	{140}
10885	330	28	{144}
10886	330	29	{153}
10887	330	30	{156}
10888	330	31	{165,169}
10889	330	32	{170}
10890	330	33	{178}
10891	331	1	{5}
10892	331	2	{9}
10893	331	3	{12}
10894	331	4	{18}
10895	331	5	{22}
10896	331	6	{28}
10897	331	7	{33}
10898	331	8	{39}
10899	331	9	{42,47,45}
10900	331	10	{54,53,51}
10901	331	11	{60}
10902	331	12	{65}
10903	331	13	{69}
10904	331	14	{75}
10905	331	15	{79}
10906	331	16	{85}
10907	331	17	{89}
10908	331	18	{94}
10909	331	19	{99}
10910	331	20	{104}
10911	331	21	{110}
10912	331	22	{115}
10913	331	23	{118}
10914	331	24	{124}
10915	331	25	{129}
10916	331	26	{132,134,136}
10917	331	27	{140}
10918	331	28	{146}
10919	331	29	{149,155}
10920	331	30	{158}
10921	331	31	{169}
10922	331	32	{170}
10923	331	33	{181,180,175}
10924	332	1	{3}
10925	332	2	{8}
10926	332	3	{13}
10927	332	4	{18}
10928	332	5	{23}
10929	332	6	{28}
10930	332	7	{33}
10931	332	8	{39}
10932	332	9	{44,41}
10933	332	10	{55,56,49}
10934	332	11	{57}
10935	332	12	{63}
10936	332	13	{69}
10937	332	14	{75}
10938	332	15	{79}
10939	332	16	{83}
10940	332	17	{88}
10941	332	18	{92}
10942	332	19	{98}
10943	332	20	{104}
10944	332	21	{110}
10945	332	22	{115}
10946	332	23	{119}
10947	332	24	{125}
10948	332	25	{129}
10949	332	26	{134,136}
10950	332	27	{139}
10951	332	28	{143}
10952	332	29	{150}
10953	332	30	{159}
10954	332	31	{161,165}
10955	332	32	{170}
10956	332	33	{177}
10957	333	1	{3}
10958	333	2	{8}
10959	333	3	{14}
10960	333	4	{20}
10961	333	5	{23}
10962	333	6	{28}
10963	333	7	{33}
10964	333	8	{38}
10965	333	9	{48,46,47}
10966	333	10	{50}
10967	333	11	{59}
10968	333	12	{64}
10969	333	13	{69}
10970	333	14	{74}
10971	333	15	{78}
10972	333	16	{84}
10973	333	17	{90}
10974	333	18	{94}
10975	333	19	{98}
10976	333	20	{104}
10977	333	21	{110}
10978	333	22	{113}
10979	333	23	{120}
10980	333	24	{125}
10981	333	25	{127}
10982	333	26	{136}
10983	333	27	{142}
10984	333	28	{145}
10985	333	29	{150,149,154}
10986	333	30	{157}
10987	333	31	{169,164}
10988	333	32	{171}
10989	333	33	{176,174}
10990	334	1	{3}
10991	334	2	{8}
10992	334	3	{13}
10993	334	4	{19}
10994	334	5	{22}
10995	334	6	{28}
10996	334	7	{32}
10997	334	8	{38}
10998	334	9	{44,43}
10999	334	10	{56}
11000	334	11	{58}
11001	334	12	{63}
11002	334	13	{70}
11003	334	14	{74}
11004	334	15	{79}
11005	334	16	{84}
11006	334	17	{89}
11007	334	18	{94}
11008	334	19	{99}
11009	334	20	{105}
11010	334	21	{110}
11011	334	22	{114}
11012	334	23	{120}
11013	334	24	{124}
11014	334	25	{128}
11015	334	26	{135,136}
11016	334	27	{139}
11017	334	28	{145}
11018	334	29	{149}
11019	334	30	{159}
11020	334	31	{162}
11021	334	32	{172}
11022	334	33	{179,181,176}
11023	335	1	{4}
11024	335	2	{8}
11025	335	3	{12}
11026	335	4	{18}
11027	335	5	{23}
11028	335	6	{29}
11029	335	7	{34}
11030	335	8	{37}
11031	335	9	{46,41}
11032	335	10	{55,56}
11033	335	11	{60}
11034	335	12	{64}
11035	335	13	{68}
11036	335	14	{75}
11037	335	15	{79}
11038	335	16	{84}
11039	335	17	{89}
11040	335	18	{94}
11041	335	19	{99}
11042	335	20	{105}
11043	335	21	{111}
11044	335	22	{114}
11045	335	23	{119}
11046	335	24	{125}
11047	335	25	{130}
11048	335	26	{133,134}
11049	335	27	{140}
11050	335	28	{144}
11051	335	29	{150}
11052	335	30	{159}
11053	335	31	{163}
11054	335	32	{171}
11055	335	33	{180}
11056	336	1	{4}
11057	336	2	{8}
11058	336	3	{14}
11059	336	4	{18}
11060	336	5	{23}
11061	336	6	{29}
11062	336	7	{33}
11063	336	8	{39}
11064	336	9	{43}
11065	336	10	{54,49}
11066	336	11	{58}
11067	336	12	{64}
11068	336	13	{69}
11069	336	14	{73}
11070	336	15	{79}
11071	336	16	{83}
11072	336	17	{90}
11073	336	18	{94}
11074	336	19	{99}
11075	336	20	{104}
11076	336	21	{110}
11077	336	22	{114}
11078	336	23	{119}
11079	336	24	{124}
11080	336	25	{128}
11081	336	26	{134,136,137}
11082	336	27	{141}
11083	336	28	{145}
11084	336	29	{150}
11085	336	30	{156}
11086	336	31	{165}
11087	336	32	{170}
11088	336	33	{179}
11089	337	1	{3}
11090	337	2	{8}
11091	337	3	{13}
11092	337	4	{17}
11093	337	5	{21}
11094	337	6	{27}
11095	337	7	{33}
11096	337	8	{38}
11097	337	9	{42,48,41}
11098	337	10	{53,50,56}
11099	337	11	{59}
11100	337	12	{64}
11101	337	13	{69}
11102	337	14	{75}
11103	337	15	{79}
11104	337	16	{85}
11105	337	17	{89}
11106	337	18	{93}
11107	337	19	{100}
11108	337	20	{102}
11109	337	21	{111}
11110	337	22	{113}
11111	337	23	{119}
11112	337	24	{124}
11113	337	25	{129}
11114	337	26	{134}
11115	337	27	{140}
11116	337	28	{145}
11117	337	29	{151,149,155}
11118	337	30	{159}
11119	337	31	{167,168}
11120	337	32	{171}
11121	337	33	{179,175}
11122	338	1	{3}
11123	338	2	{7}
11124	338	3	{13}
11125	338	4	{18}
11126	338	5	{23}
11127	338	6	{28}
11128	338	7	{35}
11129	338	8	{38}
11130	338	9	{44,47,45}
11131	338	10	{53,56}
11132	338	11	{59}
11133	338	12	{64}
11134	338	13	{69}
11135	338	14	{74}
11136	338	15	{79}
11137	338	16	{84}
11138	338	17	{90}
11139	338	18	{94}
11140	338	19	{99}
11141	338	20	{103}
11142	338	21	{110}
11143	338	22	{114}
11144	338	23	{119}
11145	338	24	{124}
11146	338	25	{130}
11147	338	26	{132,135,134}
11148	338	27	{142}
11149	338	28	{145}
11150	338	29	{152,154}
11151	338	30	{156}
11152	338	31	{163,167,161}
11153	338	32	{172}
11154	338	33	{176,180}
11155	339	1	{4}
11156	339	2	{8}
11157	339	3	{13}
11158	339	4	{19}
11159	339	5	{23}
11160	339	6	{28}
11161	339	7	{33}
11162	339	8	{39}
11163	339	9	{44,43,47}
11164	339	10	{53,56}
11165	339	11	{59}
11166	339	12	{64}
11167	339	13	{69}
11168	339	14	{74}
11169	339	15	{78}
11170	339	16	{84}
11171	339	17	{89}
11172	339	18	{94}
11173	339	19	{100}
11174	339	20	{106}
11175	339	21	{111}
11176	339	22	{114}
11177	339	23	{120}
11178	339	24	{124}
11179	339	25	{130}
11180	339	26	{133}
11181	339	27	{141}
11182	339	28	{146}
11183	339	29	{155}
11184	339	30	{160}
11185	339	31	{166}
11186	339	32	{170}
11187	339	33	{178,176,174}
11188	340	1	{3}
11189	340	2	{9}
11190	340	3	{13}
11191	340	4	{19}
11192	340	5	{21}
11193	340	6	{28}
11194	340	7	{33}
11195	340	8	{38}
11196	340	9	{42,44}
11197	340	10	{50,49}
11198	340	11	{59}
11199	340	12	{63}
11200	340	13	{69}
11201	340	14	{75}
11202	340	15	{80}
11203	340	16	{84}
11204	340	17	{91}
11205	340	18	{94}
11206	340	19	{98}
11207	340	20	{104}
11208	340	21	{109}
11209	340	22	{113}
11210	340	23	{119}
11211	340	24	{124}
11212	340	25	{129}
11213	340	26	{136,137}
11214	340	27	{140}
11215	340	28	{145}
11216	340	29	{151,154,155}
11217	340	30	{160}
11218	340	31	{164}
11219	340	32	{172}
11220	340	33	{176,180,175}
11221	341	1	{3}
11222	341	2	{8}
11223	341	3	{13}
11224	341	4	{18}
11225	341	5	{23}
11226	341	6	{28}
11227	341	7	{33}
11228	341	8	{37}
11229	341	9	{46,45}
11230	341	10	{53,51,49}
11231	341	11	{59}
11232	341	12	{64}
11233	341	13	{69}
11234	341	14	{75}
11235	341	15	{79}
11236	341	16	{85}
11237	341	17	{89}
11238	341	18	{94}
11239	341	19	{100}
11240	341	20	{103}
11241	341	21	{110}
11242	341	22	{114}
11243	341	23	{119}
11244	341	24	{123}
11245	341	25	{128}
11246	341	26	{133,137}
11247	341	27	{140}
11248	341	28	{145}
11249	341	29	{152,155}
11250	341	30	{156}
11251	341	31	{168,165}
11252	341	32	{170}
11253	341	33	{178,180}
11254	342	1	{3}
11255	342	2	{8}
11256	342	3	{13}
11257	342	4	{18}
11258	342	5	{22}
11259	342	6	{28}
11260	342	7	{34}
11261	342	8	{38}
11262	342	9	{44,41}
11263	342	10	{52}
11264	342	11	{59}
11265	342	12	{63}
11266	342	13	{70}
11267	342	14	{74}
11268	342	15	{79}
11269	342	16	{84}
11270	342	17	{89}
11271	342	18	{94}
11272	342	19	{99}
11273	342	20	{104}
11274	342	21	{110}
11275	342	22	{115}
11276	342	23	{119}
11277	342	24	{123}
11278	342	25	{128}
11279	342	26	{136}
11280	342	27	{140}
11281	342	28	{145}
11282	342	29	{155}
11283	342	30	{156}
11284	342	31	{163}
11285	342	32	{170}
11286	342	33	{178,173}
11287	343	1	{4}
11288	343	2	{7}
11289	343	3	{13}
11290	343	4	{18}
11291	343	5	{23}
11292	343	6	{28}
11293	343	7	{33}
11294	343	8	{38}
11295	343	9	{43}
11296	343	10	{50,55}
11297	343	11	{58}
11298	343	12	{63}
11299	343	13	{71}
11300	343	14	{75}
11301	343	15	{78}
11302	343	16	{84}
11303	343	17	{90}
11304	343	18	{94}
11305	343	19	{98}
11306	343	20	{106}
11307	343	21	{111}
11308	343	22	{115}
11309	343	23	{119}
11310	343	24	{123}
11311	343	25	{129}
11312	343	26	{135,134,137}
11313	343	27	{140}
11314	343	28	{145}
11315	343	29	{149}
11316	343	30	{156}
11317	343	31	{161,162}
11318	343	32	{172}
11319	343	33	{178,179,176}
11320	344	1	{4}
11321	344	2	{7}
11322	344	3	{13}
11323	344	4	{16}
11324	344	5	{23}
11325	344	6	{28}
11326	344	7	{34}
11327	344	8	{38}
11328	344	9	{44,41,47}
11329	344	10	{51,55,49}
11330	344	11	{59}
11331	344	12	{65}
11332	344	13	{69}
11333	344	14	{73}
11334	344	15	{78}
11335	344	16	{83}
11336	344	17	{89}
11337	344	18	{95}
11338	344	19	{97}
11339	344	20	{102}
11340	344	21	{111}
11341	344	22	{114}
11342	344	23	{118}
11343	344	24	{124}
11344	344	25	{127}
11345	344	26	{133,135,137}
11346	344	27	{141}
11347	344	28	{145}
11348	344	29	{148,154}
11349	344	30	{159}
11350	344	31	{161,165,169}
11351	344	32	{172}
11352	344	33	{179,173}
11353	345	1	{3}
11354	345	2	{8}
11355	345	3	{14}
11356	345	4	{18}
11357	345	5	{24}
11358	345	6	{27}
11359	345	7	{33}
11360	345	8	{38}
11361	345	9	{46,43,45}
11362	345	10	{50}
11363	345	11	{58}
11364	345	12	{62}
11365	345	13	{69}
11366	345	14	{74}
11367	345	15	{78}
11368	345	16	{84}
11369	345	17	{89}
11370	345	18	{94}
11371	345	19	{97}
11372	345	20	{104}
11373	345	21	{110}
11374	345	22	{113}
11375	345	23	{119}
11376	345	24	{122}
11377	345	25	{130}
11378	345	26	{133,132,136}
11379	345	27	{142}
11380	345	28	{145}
11381	345	29	{151,148}
11382	345	30	{159}
11383	345	31	{168}
11384	345	32	{172}
11385	345	33	{178,175,173}
11386	346	1	{3}
11387	346	2	{8}
11388	346	3	{13}
11389	346	4	{18}
11390	346	5	{23}
11391	346	6	{28}
11392	346	7	{33}
11393	346	8	{38}
11394	346	9	{42}
11395	346	10	{53,50}
11396	346	11	{59}
11397	346	12	{64}
11398	346	13	{69}
11399	346	14	{75}
11400	346	15	{79}
11401	346	16	{84}
11402	346	17	{90}
11403	346	18	{93}
11404	346	19	{99}
11405	346	20	{104}
11406	346	21	{108}
11407	346	22	{113}
11408	346	23	{121}
11409	346	24	{125}
11410	346	25	{129}
11411	346	26	{132,137}
11412	346	27	{142}
11413	346	28	{146}
11414	346	29	{148,149}
11415	346	30	{157}
11416	346	31	{168,165,164}
11417	346	32	{172}
11418	346	33	{177}
11419	347	1	{3}
11420	347	2	{8}
11421	347	3	{13}
11422	347	4	{17}
11423	347	5	{22}
11424	347	6	{26}
11425	347	7	{33}
11426	347	8	{37}
11427	347	9	{48,43,41}
11428	347	10	{51}
11429	347	11	{59}
11430	347	12	{65}
11431	347	13	{69}
11432	347	14	{75}
11433	347	15	{80}
11434	347	16	{83}
11435	347	17	{89}
11436	347	18	{95}
11437	347	19	{99}
11438	347	20	{104}
11439	347	21	{111}
11440	347	22	{114}
11441	347	23	{121}
11442	347	24	{124}
11443	347	25	{130}
11444	347	26	{132,134}
11445	347	27	{140}
11446	347	28	{145}
11447	347	29	{153,149}
11448	347	30	{157}
11449	347	31	{161}
11450	347	32	{171}
11451	347	33	{175}
11452	348	1	{2}
11453	348	2	{8}
11454	348	3	{13}
11455	348	4	{19}
11456	348	5	{22}
11457	348	6	{27}
11458	348	7	{33}
11459	348	8	{39}
11460	348	9	{41,45}
11461	348	10	{50}
11462	348	11	{59}
11463	348	12	{64}
11464	348	13	{69}
11465	348	14	{75}
11466	348	15	{79}
11467	348	16	{85}
11468	348	17	{90}
11469	348	18	{93}
11470	348	19	{100}
11471	348	20	{104}
11472	348	21	{110}
11473	348	22	{114}
11474	348	23	{119}
11475	348	24	{124}
11476	348	25	{128}
11477	348	26	{137}
11478	348	27	{140}
11479	348	28	{145}
11480	348	29	{150}
11481	348	30	{157}
11482	348	31	{168}
11483	348	32	{170}
11484	348	33	{181,175}
11485	349	1	{2}
11486	349	2	{8}
11487	349	3	{13}
11488	349	4	{18}
11489	349	5	{23}
11490	349	6	{28}
11491	349	7	{33}
11492	349	8	{38}
11493	349	9	{42,45}
11494	349	10	{55}
11495	349	11	{59}
11496	349	12	{64}
11497	349	13	{69}
11498	349	14	{73}
11499	349	15	{79}
11500	349	16	{85}
11501	349	17	{89}
11502	349	18	{94}
11503	349	19	{99}
11504	349	20	{105}
11505	349	21	{111}
11506	349	22	{114}
11507	349	23	{118}
11508	349	24	{124}
11509	349	25	{128}
11510	349	26	{132,134,137}
11511	349	27	{139}
11512	349	28	{145}
11513	349	29	{151,149}
11514	349	30	{157}
11515	349	31	{163,168,162}
11516	349	32	{170}
11517	349	33	{178,176}
11518	350	1	{1}
11519	350	2	{8}
11520	350	3	{13}
11521	350	4	{18}
11522	350	5	{23}
11523	350	6	{28}
11524	350	7	{34}
11525	350	8	{39}
11526	350	9	{42,46,41}
11527	350	10	{50,55,52}
11528	350	11	{59}
11529	350	12	{64}
11530	350	13	{69}
11531	350	14	{74}
11532	350	15	{79}
11533	350	16	{83}
11534	350	17	{90}
11535	350	18	{93}
11536	350	19	{99}
11537	350	20	{103}
11538	350	21	{110}
11539	350	22	{114}
11540	350	23	{118}
11541	350	24	{124}
11542	350	25	{129}
11543	350	26	{135}
11544	350	27	{140}
11545	350	28	{145}
11546	350	29	{148,152,150}
11547	350	30	{158}
11548	350	31	{166,168,161}
11549	350	32	{172}
11550	350	33	{178,181,180}
11551	351	1	{5}
11552	351	2	{8}
11553	351	3	{14}
11554	351	4	{18}
11555	351	5	{24}
11556	351	6	{28}
11557	351	7	{33}
11558	351	8	{38}
11559	351	9	{42,45}
11560	351	10	{51}
11561	351	11	{59}
11562	351	12	{64}
11563	351	13	{69}
11564	351	14	{74}
11565	351	15	{79}
11566	351	16	{84}
11567	351	17	{89}
11568	351	18	{95}
11569	351	19	{99}
11570	351	20	{104}
11571	351	21	{110}
11572	351	22	{115}
11573	351	23	{118}
11574	351	24	{123}
11575	351	25	{129}
11576	351	26	{133,137}
11577	351	27	{140}
11578	351	28	{145}
11579	351	29	{153,155}
11580	351	30	{157}
11581	351	31	{163,167}
11582	351	32	{172}
11583	351	33	{181,176,175}
11584	352	1	{3}
11585	352	2	{8}
11586	352	3	{13}
11587	352	4	{18}
11588	352	5	{23}
11589	352	6	{28}
11590	352	7	{33}
11591	352	8	{37}
11592	352	9	{45}
11593	352	10	{53}
11594	352	11	{58}
11595	352	12	{64}
11596	352	13	{69}
11597	352	14	{73}
11598	352	15	{79}
11599	352	16	{85}
11600	352	17	{89}
11601	352	18	{93}
11602	352	19	{101}
11603	352	20	{104}
11604	352	21	{110}
11605	352	22	{115}
11606	352	23	{120}
11607	352	24	{123}
11608	352	25	{129}
11609	352	26	{132,135,134}
11610	352	27	{140}
11611	352	28	{145}
11612	352	29	{152,150,149}
11613	352	30	{156}
11614	352	31	{168}
11615	352	32	{170}
11616	352	33	{178,180}
11617	353	1	{5}
11618	353	2	{8}
11619	353	3	{12}
11620	353	4	{18}
11621	353	5	{23}
11622	353	6	{27}
11623	353	7	{33}
11624	353	8	{37}
11625	353	9	{48}
11626	353	10	{54,49}
11627	353	11	{59}
11628	353	12	{64}
11629	353	13	{69}
11630	353	14	{73}
11631	353	15	{79}
11632	353	16	{84}
11633	353	17	{88}
11634	353	18	{96}
11635	353	19	{97}
11636	353	20	{106}
11637	353	21	{110}
11638	353	22	{114}
11639	353	23	{119}
11640	353	24	{122}
11641	353	25	{128}
11642	353	26	{135,134}
11643	353	27	{138}
11644	353	28	{145}
11645	353	29	{152,150,155}
11646	353	30	{159}
11647	353	31	{169}
11648	353	32	{172}
11649	353	33	{178,179,180}
11650	354	1	{3}
11651	354	2	{8}
11652	354	3	{12}
11653	354	4	{18}
11654	354	5	{24}
11655	354	6	{28}
11656	354	7	{32}
11657	354	8	{38}
11658	354	9	{42,44,43}
11659	354	10	{50,55,52}
11660	354	11	{59}
11661	354	12	{65}
11662	354	13	{70}
11663	354	14	{73}
11664	354	15	{81}
11665	354	16	{83}
11666	354	17	{89}
11667	354	18	{94}
11668	354	19	{99}
11669	354	20	{105}
11670	354	21	{110}
11671	354	22	{114}
11672	354	23	{118}
11673	354	24	{124}
11674	354	25	{129}
11675	354	26	{135}
11676	354	27	{140}
11677	354	28	{145}
11678	354	29	{153,155}
11679	354	30	{158}
11680	354	31	{167,168,162}
11681	354	32	{172}
11682	354	33	{179,174,173}
11683	355	1	{3}
11684	355	2	{8}
11685	355	3	{13}
11686	355	4	{18}
11687	355	5	{24}
11688	355	6	{28}
11689	355	7	{34}
11690	355	8	{38}
11691	355	9	{42,41,47}
11692	355	10	{53,50,56}
11693	355	11	{59}
11694	355	12	{64}
11695	355	13	{69}
11696	355	14	{74}
11697	355	15	{79}
11698	355	16	{83}
11699	355	17	{89}
11700	355	18	{94}
11701	355	19	{99}
11702	355	20	{104}
11703	355	21	{110}
11704	355	22	{115}
11705	355	23	{120}
11706	355	24	{124}
11707	355	25	{131}
11708	355	26	{136}
11709	355	27	{139}
11710	355	28	{145}
11711	355	29	{149,154}
11712	355	30	{156}
11713	355	31	{167,169}
11714	355	32	{172}
11715	355	33	{178,174}
11716	356	1	{3}
11717	356	2	{8}
11718	356	3	{13}
11719	356	4	{18}
11720	356	5	{23}
11721	356	6	{28}
11722	356	7	{32}
11723	356	8	{38}
11724	356	9	{48,43,45}
11725	356	10	{53,50}
11726	356	11	{60}
11727	356	12	{63}
11728	356	13	{68}
11729	356	14	{73}
11730	356	15	{78}
11731	356	16	{84}
11732	356	17	{89}
11733	356	18	{94}
11734	356	19	{99}
11735	356	20	{105}
11736	356	21	{110}
11737	356	22	{114}
11738	356	23	{120}
11739	356	24	{124}
11740	356	25	{129}
11741	356	26	{136}
11742	356	27	{138}
11743	356	28	{145}
11744	356	29	{154,155}
11745	356	30	{160}
11746	356	31	{163,166}
11747	356	32	{170}
11748	356	33	{181,175}
11749	357	1	{3}
11750	357	2	{8}
11751	357	3	{14}
11752	357	4	{18}
11753	357	5	{21}
11754	357	6	{28}
11755	357	7	{32}
11756	357	8	{39}
11757	357	9	{48,44,47}
11758	357	10	{54,51}
11759	357	11	{59}
11760	357	12	{64}
11761	357	13	{68}
11762	357	14	{75}
11763	357	15	{79}
11764	357	16	{84}
11765	357	17	{90}
11766	357	18	{93}
11767	357	19	{100}
11768	357	20	{104}
11769	357	21	{111}
11770	357	22	{115}
11771	357	23	{119}
11772	357	24	{124}
11773	357	25	{130}
11774	357	26	{136}
11775	357	27	{142}
11776	357	28	{145}
11777	357	29	{152}
11778	357	30	{158}
11779	357	31	{166,162}
11780	357	32	{172}
11781	357	33	{178}
11782	358	1	{2}
11783	358	2	{8}
11784	358	3	{13}
11785	358	4	{18}
11786	358	5	{23}
11787	358	6	{28}
11788	358	7	{34}
11789	358	8	{38}
11790	358	9	{44}
11791	358	10	{55,49}
11792	358	11	{60}
11793	358	12	{64}
11794	358	13	{69}
11795	358	14	{73}
11796	358	15	{80}
11797	358	16	{83}
11798	358	17	{89}
11799	358	18	{95}
11800	358	19	{99}
11801	358	20	{103}
11802	358	21	{109}
11803	358	22	{116}
11804	358	23	{120}
11805	358	24	{125}
11806	358	25	{130}
11807	358	26	{137}
11808	358	27	{141}
11809	358	28	{147}
11810	358	29	{148,152}
11811	358	30	{157}
11812	358	31	{167,169}
11813	358	32	{172}
11814	358	33	{178,181,175}
11815	359	1	{3}
11816	359	2	{8}
11817	359	3	{13}
11818	359	4	{17}
11819	359	5	{24}
11820	359	6	{30}
11821	359	7	{33}
11822	359	8	{38}
11823	359	9	{42,44,41}
11824	359	10	{50,56,49}
11825	359	11	{61}
11826	359	12	{64}
11827	359	13	{70}
11828	359	14	{74}
11829	359	15	{78}
11830	359	16	{83}
11831	359	17	{89}
11832	359	18	{93}
11833	359	19	{98}
11834	359	20	{104}
11835	359	21	{110}
11836	359	22	{114}
11837	359	23	{119}
11838	359	24	{123}
11839	359	25	{128}
11840	359	26	{135,137}
11841	359	27	{139}
11842	359	28	{145}
11843	359	29	{148,149}
11844	359	30	{157}
11845	359	31	{167}
11846	359	32	{171}
11847	359	33	{181}
11848	360	1	{3}
11849	360	2	{8}
11850	360	3	{13}
11851	360	4	{18}
11852	360	5	{24}
11853	360	6	{28}
11854	360	7	{33}
11855	360	8	{38}
11856	360	9	{42,48,46}
11857	360	10	{53,50,55}
11858	360	11	{59}
11859	360	12	{62}
11860	360	13	{69}
11861	360	14	{75}
11862	360	15	{79}
11863	360	16	{82}
11864	360	17	{89}
11865	360	18	{93}
11866	360	19	{100}
11867	360	20	{103}
11868	360	21	{110}
11869	360	22	{114}
11870	360	23	{119}
11871	360	24	{122}
11872	360	25	{129}
11873	360	26	{136}
11874	360	27	{140}
11875	360	28	{145}
11876	360	29	{154}
11877	360	30	{159}
11878	360	31	{165}
11879	360	32	{171}
11880	360	33	{178,175,177}
11881	361	1	{4}
11882	361	2	{9}
11883	361	3	{13}
11884	361	4	{18}
11885	361	5	{22}
11886	361	6	{28}
11887	361	7	{33}
11888	361	8	{37}
11889	361	9	{46,47}
11890	361	10	{55,56,49}
11891	361	11	{60}
11892	361	12	{63}
11893	361	13	{68}
11894	361	14	{74}
11895	361	15	{79}
11896	361	16	{82}
11897	361	17	{88}
11898	361	18	{94}
11899	361	19	{99}
11900	361	20	{104}
11901	361	21	{111}
11902	361	22	{115}
11903	361	23	{119}
11904	361	24	{124}
11905	361	25	{129}
11906	361	26	{133,134,136}
11907	361	27	{140}
11908	361	28	{145}
11909	361	29	{151,150}
11910	361	30	{160}
11911	361	31	{161}
11912	361	32	{172}
11913	361	33	{178,175}
11914	362	1	{4}
11915	362	2	{8}
11916	362	3	{13}
11917	362	4	{19}
11918	362	5	{24}
11919	362	6	{29}
11920	362	7	{34}
11921	362	8	{36}
11922	362	9	{46,43,45}
11923	362	10	{56,52}
11924	362	11	{59}
11925	362	12	{65}
11926	362	13	{69}
11927	362	14	{73}
11928	362	15	{81}
11929	362	16	{83}
11930	362	17	{89}
11931	362	18	{94}
11932	362	19	{99}
11933	362	20	{104}
11934	362	21	{110}
11935	362	22	{115}
11936	362	23	{119}
11937	362	24	{124}
11938	362	25	{129}
11939	362	26	{132,135,134}
11940	362	27	{140}
11941	362	28	{145}
11942	362	29	{149,154}
11943	362	30	{157}
11944	362	31	{162,164}
11945	362	32	{172}
11946	362	33	{181,175,177}
11947	363	1	{4}
11948	363	2	{8}
11949	363	3	{13}
11950	363	4	{20}
11951	363	5	{23}
11952	363	6	{28}
11953	363	7	{33}
11954	363	8	{38}
11955	363	9	{42,45}
11956	363	10	{53,56,52}
11957	363	11	{59}
11958	363	12	{64}
11959	363	13	{69}
11960	363	14	{75}
11961	363	15	{79}
11962	363	16	{85}
11963	363	17	{88}
11964	363	18	{94}
11965	363	19	{99}
11966	363	20	{105}
11967	363	21	{110}
11968	363	22	{114}
11969	363	23	{119}
11970	363	24	{124}
11971	363	25	{128}
11972	363	26	{133,137}
11973	363	27	{139}
11974	363	28	{145}
11975	363	29	{153}
11976	363	30	{156}
11977	363	31	{167,168}
11978	363	32	{171}
11979	363	33	{176,180,173}
11980	364	1	{3}
11981	364	2	{8}
11982	364	3	{13}
11983	364	4	{18}
11984	364	5	{23}
11985	364	6	{28}
11986	364	7	{33}
11987	364	8	{37}
11988	364	9	{44}
11989	364	10	{56}
11990	364	11	{59}
11991	364	12	{64}
11992	364	13	{68}
11993	364	14	{74}
11994	364	15	{79}
11995	364	16	{84}
11996	364	17	{89}
11997	364	18	{95}
11998	364	19	{99}
11999	364	20	{104}
12000	364	21	{111}
12001	364	22	{112}
12002	364	23	{119}
12003	364	24	{125}
12004	364	25	{129}
12005	364	26	{134}
12006	364	27	{139}
12007	364	28	{145}
12008	364	29	{151}
12009	364	30	{156}
12010	364	31	{165}
12011	364	32	{170}
12012	364	33	{176,175,177}
12013	365	1	{4}
12014	365	2	{9}
12015	365	3	{12}
12016	365	4	{17}
12017	365	5	{23}
12018	365	6	{28}
12019	365	7	{34}
12020	365	8	{39}
12021	365	9	{48,44}
12022	365	10	{54,55}
12023	365	11	{58}
12024	365	12	{64}
12025	365	13	{68}
12026	365	14	{74}
12027	365	15	{79}
12028	365	16	{83}
12029	365	17	{89}
12030	365	18	{94}
12031	365	19	{99}
12032	365	20	{103}
12033	365	21	{110}
12034	365	22	{113}
12035	365	23	{119}
12036	365	24	{124}
12037	365	25	{130}
12038	365	26	{132,135,134}
12039	365	27	{140}
12040	365	28	{143}
12041	365	29	{150,149,155}
12042	365	30	{159}
12043	365	31	{163,166,164}
12044	365	32	{170}
12045	365	33	{174}
12046	366	1	{4}
12047	366	2	{8}
12048	366	3	{11}
12049	366	4	{17}
12050	366	5	{23}
12051	366	6	{28}
12052	366	7	{33}
12053	366	8	{38}
12054	366	9	{48,44,47}
12055	366	10	{50,51,56}
12056	366	11	{59}
12057	366	12	{64}
12058	366	13	{69}
12059	366	14	{73}
12060	366	15	{79}
12061	366	16	{85}
12062	366	17	{89}
12063	366	18	{93}
12064	366	19	{99}
12065	366	20	{104}
12066	366	21	{111}
12067	366	22	{114}
12068	366	23	{118}
12069	366	24	{124}
12070	366	25	{130}
12071	366	26	{133,135,134}
12072	366	27	{140}
12073	366	28	{145}
12074	366	29	{148,149,155}
12075	366	30	{160}
12076	366	31	{166}
12077	366	32	{172}
12078	366	33	{178,176,180}
12079	367	1	{3}
12080	367	2	{10}
12081	367	3	{13}
12082	367	4	{18}
12083	367	5	{22}
12084	367	6	{30}
12085	367	7	{32}
12086	367	8	{38}
12087	367	9	{46,43}
12088	367	10	{54,49}
12089	367	11	{59}
12090	367	12	{65}
12091	367	13	{70}
12092	367	14	{75}
12093	367	15	{79}
12094	367	16	{83}
12095	367	17	{89}
12096	367	18	{94}
12097	367	19	{100}
12098	367	20	{104}
12099	367	21	{110}
12100	367	22	{115}
12101	367	23	{121}
12102	367	24	{125}
12103	367	25	{127}
12104	367	26	{136}
12105	367	27	{140}
12106	367	28	{145}
12107	367	29	{153,150,155}
12108	367	30	{157}
12109	367	31	{162,164}
12110	367	32	{171}
12111	367	33	{176,174}
12112	368	1	{2}
12113	368	2	{8}
12114	368	3	{13}
12115	368	4	{18}
12116	368	5	{22}
12117	368	6	{28}
12118	368	7	{33}
12119	368	8	{37}
12120	368	9	{46,44,43}
12121	368	10	{49}
12122	368	11	{58}
12123	368	12	{64}
12124	368	13	{69}
12125	368	14	{75}
12126	368	15	{79}
12127	368	16	{84}
12128	368	17	{89}
12129	368	18	{94}
12130	368	19	{99}
12131	368	20	{104}
12132	368	21	{109}
12133	368	22	{114}
12134	368	23	{119}
12135	368	24	{124}
12136	368	25	{129}
12137	368	26	{132,135}
12138	368	27	{140}
12139	368	28	{144}
12140	368	29	{150}
12141	368	30	{160}
12142	368	31	{163,161,169}
12143	368	32	{171}
12144	368	33	{175}
12145	369	1	{3}
12146	369	2	{8}
12147	369	3	{14}
12148	369	4	{18}
12149	369	5	{24}
12150	369	6	{28}
12151	369	7	{34}
12152	369	8	{38}
12153	369	9	{44}
12154	369	10	{51,52}
12155	369	11	{59}
12156	369	12	{64}
12157	369	13	{68}
12158	369	14	{74}
12159	369	15	{79}
12160	369	16	{82}
12161	369	17	{89}
12162	369	18	{94}
12163	369	19	{99}
12164	369	20	{104}
12165	369	21	{110}
12166	369	22	{114}
12167	369	23	{119}
12168	369	24	{124}
12169	369	25	{129}
12170	369	26	{136,137}
12171	369	27	{139}
12172	369	28	{145}
12173	369	29	{153}
12174	369	30	{158}
12175	369	31	{167}
12176	369	32	{172}
12177	369	33	{181,175,174}
12178	370	1	{3}
12179	370	2	{10}
12180	370	3	{13}
12181	370	4	{18}
12182	370	5	{23}
12183	370	6	{29}
12184	370	7	{33}
12185	370	8	{38}
12186	370	9	{44}
12187	370	10	{53,49,52}
12188	370	11	{59}
12189	370	12	{64}
12190	370	13	{70}
12191	370	14	{74}
12192	370	15	{79}
12193	370	16	{83}
12194	370	17	{89}
12195	370	18	{94}
12196	370	19	{100}
12197	370	20	{104}
12198	370	21	{110}
12199	370	22	{114}
12200	370	23	{118}
12201	370	24	{123}
12202	370	25	{129}
12203	370	26	{137}
12204	370	27	{140}
12205	370	28	{145}
12206	370	29	{150}
12207	370	30	{160}
12208	370	31	{169,164}
12209	370	32	{172}
12210	370	33	{180,174,177}
12211	371	1	{3}
12212	371	2	{7}
12213	371	3	{12}
12214	371	4	{18}
12215	371	5	{23}
12216	371	6	{28}
12217	371	7	{33}
12218	371	8	{37}
12219	371	9	{48,45}
12220	371	10	{53,51,49}
12221	371	11	{59}
12222	371	12	{64}
12223	371	13	{68}
12224	371	14	{74}
12225	371	15	{79}
12226	371	16	{84}
12227	371	17	{88}
12228	371	18	{95}
12229	371	19	{100}
12230	371	20	{104}
12231	371	21	{110}
12232	371	22	{115}
12233	371	23	{119}
12234	371	24	{123}
12235	371	25	{130}
12236	371	26	{132,134}
12237	371	27	{140}
12238	371	28	{145}
12239	371	29	{148}
12240	371	30	{156}
12241	371	31	{166,161,169}
12242	371	32	{170}
12243	371	33	{180,175}
12244	372	1	{1}
12245	372	2	{8}
12246	372	3	{13}
12247	372	4	{18}
12248	372	5	{24}
12249	372	6	{27}
12250	372	7	{33}
12251	372	8	{39}
12252	372	9	{48,41}
12253	372	10	{54,53,50}
12254	372	11	{59}
12255	372	12	{65}
12256	372	13	{69}
12257	372	14	{75}
12258	372	15	{79}
12259	372	16	{84}
12260	372	17	{89}
12261	372	18	{94}
12262	372	19	{99}
12263	372	20	{106}
12264	372	21	{110}
12265	372	22	{113}
12266	372	23	{119}
12267	372	24	{124}
12268	372	25	{129}
12269	372	26	{133,132}
12270	372	27	{140}
12271	372	28	{146}
12272	372	29	{153}
12273	372	30	{159}
12274	372	31	{166}
12275	372	32	{171}
12276	372	33	{180}
12277	373	1	{3}
12278	373	2	{8}
12279	373	3	{13}
12280	373	4	{18}
12281	373	5	{22}
12282	373	6	{29}
12283	373	7	{33}
12284	373	8	{37}
12285	373	9	{48,46,44}
12286	373	10	{54}
12287	373	11	{60}
12288	373	12	{64}
12289	373	13	{69}
12290	373	14	{74}
12291	373	15	{79}
12292	373	16	{83}
12293	373	17	{89}
12294	373	18	{93}
12295	373	19	{100}
12296	373	20	{104}
12297	373	21	{110}
12298	373	22	{113}
12299	373	23	{119}
12300	373	24	{124}
12301	373	25	{128}
12302	373	26	{133,132,137}
12303	373	27	{141}
12304	373	28	{145}
12305	373	29	{155}
12306	373	30	{157}
12307	373	31	{162,165}
12308	373	32	{171}
12309	373	33	{176,180,173}
12310	374	1	{3}
12311	374	2	{8}
12312	374	3	{13}
12313	374	4	{19}
12314	374	5	{23}
12315	374	6	{27}
12316	374	7	{33}
12317	374	8	{39}
12318	374	9	{42,43,41}
12319	374	10	{53,51,52}
12320	374	11	{59}
12321	374	12	{64}
12322	374	13	{70}
12323	374	14	{74}
12324	374	15	{79}
12325	374	16	{84}
12326	374	17	{89}
12327	374	18	{92}
12328	374	19	{99}
12329	374	20	{104}
12330	374	21	{110}
12331	374	22	{113}
12332	374	23	{120}
12333	374	24	{123}
12334	374	25	{129}
12335	374	26	{132,135,136}
12336	374	27	{139}
12337	374	28	{144}
12338	374	29	{152}
12339	374	30	{157}
12340	374	31	{161,169}
12341	374	32	{171}
12342	374	33	{176,177}
12343	375	1	{4}
12344	375	2	{7}
12345	375	3	{14}
12346	375	4	{18}
12347	375	5	{23}
12348	375	6	{29}
12349	375	7	{33}
12350	375	8	{37}
12351	375	9	{48}
12352	375	10	{53,56,49}
12353	375	11	{57}
12354	375	12	{64}
12355	375	13	{69}
12356	375	14	{74}
12357	375	15	{78}
12358	375	16	{84}
12359	375	17	{90}
12360	375	18	{95}
12361	375	19	{99}
12362	375	20	{104}
12363	375	21	{110}
12364	375	22	{114}
12365	375	23	{119}
12366	375	24	{124}
12367	375	25	{129}
12368	375	26	{132,134}
12369	375	27	{140}
12370	375	28	{146}
12371	375	29	{151,152,154}
12372	375	30	{160}
12373	375	31	{167,166}
12374	375	32	{170}
12375	375	33	{181,174,173}
12376	376	1	{4}
12377	376	2	{8}
12378	376	3	{13}
12379	376	4	{18}
12380	376	5	{23}
12381	376	6	{27}
12382	376	7	{32}
12383	376	8	{38}
12384	376	9	{47,45}
12385	376	10	{50}
12386	376	11	{57}
12387	376	12	{64}
12388	376	13	{68}
12389	376	14	{74}
12390	376	15	{80}
12391	376	16	{84}
12392	376	17	{88}
12393	376	18	{94}
12394	376	19	{98}
12395	376	20	{104}
12396	376	21	{109}
12397	376	22	{113}
12398	376	23	{117}
12399	376	24	{125}
12400	376	25	{128}
12401	376	26	{137}
12402	376	27	{140}
12403	376	28	{144}
12404	376	29	{153,149}
12405	376	30	{156}
12406	376	31	{163,165}
12407	376	32	{170}
12408	376	33	{176,180,177}
12409	377	1	{3}
12410	377	2	{8}
12411	377	3	{13}
12412	377	4	{18}
12413	377	5	{22}
12414	377	6	{28}
12415	377	7	{32}
12416	377	8	{38}
12417	377	9	{48}
12418	377	10	{53,49}
12419	377	11	{60}
12420	377	12	{65}
12421	377	13	{69}
12422	377	14	{73}
12423	377	15	{80}
12424	377	16	{84}
12425	377	17	{89}
12426	377	18	{94}
12427	377	19	{99}
12428	377	20	{104}
12429	377	21	{111}
12430	377	22	{115}
12431	377	23	{119}
12432	377	24	{123}
12433	377	25	{129}
12434	377	26	{137}
12435	377	27	{140}
12436	377	28	{145}
12437	377	29	{153}
12438	377	30	{158}
12439	377	31	{167}
12440	377	32	{171}
12441	377	33	{181,174,177}
12442	378	1	{3}
12443	378	2	{8}
12444	378	3	{12}
12445	378	4	{18}
12446	378	5	{23}
12447	378	6	{28}
12448	378	7	{33}
12449	378	8	{38}
12450	378	9	{42,44,47}
12451	378	10	{55}
12452	378	11	{59}
12453	378	12	{64}
12454	378	13	{69}
12455	378	14	{75}
12456	378	15	{79}
12457	378	16	{83}
12458	378	17	{88}
12459	378	18	{93}
12460	378	19	{99}
12461	378	20	{103}
12462	378	21	{111}
12463	378	22	{114}
12464	378	23	{119}
12465	378	24	{125}
12466	378	25	{128}
12467	378	26	{133,132,135}
12468	378	27	{140}
12469	378	28	{144}
12470	378	29	{153,152,150}
12471	378	30	{157}
12472	378	31	{166,165}
12473	378	32	{171}
12474	378	33	{179,176,180}
12475	379	1	{3}
12476	379	2	{9}
12477	379	3	{13}
12478	379	4	{19}
12479	379	5	{23}
12480	379	6	{27}
12481	379	7	{33}
12482	379	8	{38}
12483	379	9	{42,41}
12484	379	10	{56}
12485	379	11	{58}
12486	379	12	{64}
12487	379	13	{69}
12488	379	14	{73}
12489	379	15	{78}
12490	379	16	{84}
12491	379	17	{89}
12492	379	18	{93}
12493	379	19	{99}
12494	379	20	{105}
12495	379	21	{110}
12496	379	22	{114}
12497	379	23	{120}
12498	379	24	{124}
12499	379	25	{128}
12500	379	26	{136}
12501	379	27	{140}
12502	379	28	{145}
12503	379	29	{154,155}
12504	379	30	{159}
12505	379	31	{164}
12506	379	32	{172}
12507	379	33	{178,173}
12508	380	1	{2}
12509	380	2	{9}
12510	380	3	{13}
12511	380	4	{18}
12512	380	5	{25}
12513	380	6	{29}
12514	380	7	{33}
12515	380	8	{38}
12516	380	9	{42,46,44}
12517	380	10	{56}
12518	380	11	{59}
12519	380	12	{64}
12520	380	13	{68}
12521	380	14	{75}
12522	380	15	{78}
12523	380	16	{84}
12524	380	17	{89}
12525	380	18	{95}
12526	380	19	{99}
12527	380	20	{104}
12528	380	21	{110}
12529	380	22	{113}
12530	380	23	{119}
12531	380	24	{122}
12532	380	25	{129}
12533	380	26	{133}
12534	380	27	{140}
12535	380	28	{144}
12536	380	29	{152,149}
12537	380	30	{158}
12538	380	31	{163,167,168}
12539	380	32	{171}
12540	380	33	{173}
12541	381	1	{3}
12542	381	2	{6}
12543	381	3	{15}
12544	381	4	{19}
12545	381	5	{22}
12546	381	6	{28}
12547	381	7	{33}
12548	381	8	{38}
12549	381	9	{41}
12550	381	10	{55,49,52}
12551	381	11	{59}
12552	381	12	{63}
12553	381	13	{70}
12554	381	14	{74}
12555	381	15	{79}
12556	381	16	{84}
12557	381	17	{90}
12558	381	18	{94}
12559	381	19	{100}
12560	381	20	{103}
12561	381	21	{109}
12562	381	22	{113}
12563	381	23	{118}
12564	381	24	{124}
12565	381	25	{128}
12566	381	26	{133,134}
12567	381	27	{139}
12568	381	28	{145}
12569	381	29	{151,149,155}
12570	381	30	{157}
12571	381	31	{168}
12572	381	32	{170}
12573	381	33	{173}
12574	382	1	{2}
12575	382	2	{8}
12576	382	3	{12}
12577	382	4	{18}
12578	382	5	{22}
12579	382	6	{28}
12580	382	7	{33}
12581	382	8	{39}
12582	382	9	{42,46,44}
12583	382	10	{53,50}
12584	382	11	{57}
12585	382	12	{62}
12586	382	13	{71}
12587	382	14	{74}
12588	382	15	{80}
12589	382	16	{84}
12590	382	17	{88}
12591	382	18	{94}
12592	382	19	{100}
12593	382	20	{104}
12594	382	21	{111}
12595	382	22	{114}
12596	382	23	{119}
12597	382	24	{124}
12598	382	25	{129}
12599	382	26	{136}
12600	382	27	{140}
12601	382	28	{145}
12602	382	29	{150}
12603	382	30	{157}
12604	382	31	{163}
12605	382	32	{171}
12606	382	33	{176,174}
12607	383	1	{3}
12608	383	2	{8}
12609	383	3	{13}
12610	383	4	{18}
12611	383	5	{23}
12612	383	6	{28}
12613	383	7	{35}
12614	383	8	{37}
12615	383	9	{41,45}
12616	383	10	{50,56}
12617	383	11	{58}
12618	383	12	{64}
12619	383	13	{71}
12620	383	14	{74}
12621	383	15	{79}
12622	383	16	{84}
12623	383	17	{89}
12624	383	18	{95}
12625	383	19	{99}
12626	383	20	{103}
12627	383	21	{111}
12628	383	22	{113}
12629	383	23	{119}
12630	383	24	{123}
12631	383	25	{128}
12632	383	26	{134}
12633	383	27	{140}
12634	383	28	{145}
12635	383	29	{155}
12636	383	30	{159}
12637	383	31	{166}
12638	383	32	{171}
12639	383	33	{175,174}
12640	384	1	{3}
12641	384	2	{8}
12642	384	3	{12}
12643	384	4	{18}
12644	384	5	{23}
12645	384	6	{27}
12646	384	7	{32}
12647	384	8	{37}
12648	384	9	{42,48,46}
12649	384	10	{51,56,49}
12650	384	11	{59}
12651	384	12	{63}
12652	384	13	{68}
12653	384	14	{73}
12654	384	15	{80}
12655	384	16	{85}
12656	384	17	{90}
12657	384	18	{93}
12658	384	19	{98}
12659	384	20	{104}
12660	384	21	{111}
12661	384	22	{113}
12662	384	23	{120}
12663	384	24	{124}
12664	384	25	{129}
12665	384	26	{132,134}
12666	384	27	{140}
12667	384	28	{145}
12668	384	29	{149}
12669	384	30	{156}
12670	384	31	{167,168,162}
12671	384	32	{172}
12672	384	33	{175}
12673	385	1	{2}
12674	385	2	{8}
12675	385	3	{13}
12676	385	4	{18}
12677	385	5	{23}
12678	385	6	{28}
12679	385	7	{33}
12680	385	8	{39}
12681	385	9	{48,46,45}
12682	385	10	{54,55,49}
12683	385	11	{60}
12684	385	12	{64}
12685	385	13	{69}
12686	385	14	{75}
12687	385	15	{79}
12688	385	16	{84}
12689	385	17	{88}
12690	385	18	{94}
12691	385	19	{99}
12692	385	20	{104}
12693	385	21	{110}
12694	385	22	{114}
12695	385	23	{119}
12696	385	24	{124}
12697	385	25	{129}
12698	385	26	{133,132,137}
12699	385	27	{141}
12700	385	28	{147}
12701	385	29	{154}
12702	385	30	{157}
12703	385	31	{163}
12704	385	32	{170}
12705	385	33	{181}
12706	386	1	{2}
12707	386	2	{8}
12708	386	3	{15}
12709	386	4	{18}
12710	386	5	{24}
12711	386	6	{28}
12712	386	7	{33}
12713	386	8	{38}
12714	386	9	{46,45}
12715	386	10	{51,49}
12716	386	11	{59}
12717	386	12	{64}
12718	386	13	{69}
12719	386	14	{76}
12720	386	15	{77}
12721	386	16	{86}
12722	386	17	{89}
12723	386	18	{93}
12724	386	19	{98}
12725	386	20	{103}
12726	386	21	{110}
12727	386	22	{115}
12728	386	23	{119}
12729	386	24	{125}
12730	386	25	{129}
12731	386	26	{132,136,137}
12732	386	27	{140}
12733	386	28	{145}
12734	386	29	{151,149}
12735	386	30	{157}
12736	386	31	{168}
12737	386	32	{171}
12738	386	33	{177}
12739	387	1	{3}
12740	387	2	{9}
12741	387	3	{13}
12742	387	4	{18}
12743	387	5	{23}
12744	387	6	{29}
12745	387	7	{32}
12746	387	8	{38}
12747	387	9	{42,43,47}
12748	387	10	{55,56,52}
12749	387	11	{59}
12750	387	12	{64}
12751	387	13	{68}
12752	387	14	{73}
12753	387	15	{79}
12754	387	16	{84}
12755	387	17	{89}
12756	387	18	{93}
12757	387	19	{98}
12758	387	20	{104}
12759	387	21	{109}
12760	387	22	{115}
12761	387	23	{120}
12762	387	24	{123}
12763	387	25	{129}
12764	387	26	{137}
12765	387	27	{140}
12766	387	28	{144}
12767	387	29	{148,152}
12768	387	30	{159}
12769	387	31	{167,162,165}
12770	387	32	{172}
12771	387	33	{173}
12772	388	1	{3}
12773	388	2	{8}
12774	388	3	{13}
12775	388	4	{17}
12776	388	5	{23}
12777	388	6	{28}
12778	388	7	{33}
12779	388	8	{38}
12780	388	9	{42}
12781	388	10	{55,49}
12782	388	11	{59}
12783	388	12	{64}
12784	388	13	{69}
12785	388	14	{73}
12786	388	15	{80}
12787	388	16	{84}
12788	388	17	{89}
12789	388	18	{93}
12790	388	19	{99}
12791	388	20	{105}
12792	388	21	{109}
12793	388	22	{114}
12794	388	23	{119}
12795	388	24	{124}
12796	388	25	{129}
12797	388	26	{132,135,134}
12798	388	27	{140}
12799	388	28	{145}
12800	388	29	{153}
12801	388	30	{158}
12802	388	31	{168,164}
12803	388	32	{171}
12804	388	33	{180}
12805	389	1	{3}
12806	389	2	{8}
12807	389	3	{11}
12808	389	4	{18}
12809	389	5	{23}
12810	389	6	{30}
12811	389	7	{32}
12812	389	8	{38}
12813	389	9	{42,47}
12814	389	10	{51,55}
12815	389	11	{59}
12816	389	12	{62}
12817	389	13	{68}
12818	389	14	{74}
12819	389	15	{78}
12820	389	16	{85}
12821	389	17	{88}
12822	389	18	{96}
12823	389	19	{98}
12824	389	20	{103}
12825	389	21	{110}
12826	389	22	{114}
12827	389	23	{119}
12828	389	24	{125}
12829	389	25	{129}
12830	389	26	{137}
12831	389	27	{140}
12832	389	28	{145}
12833	389	29	{152,150,149}
12834	389	30	{159}
12835	389	31	{167,169}
12836	389	32	{171}
12837	389	33	{178,175,177}
12838	390	1	{3}
12839	390	2	{7}
12840	390	3	{13}
12841	390	4	{16}
12842	390	5	{23}
12843	390	6	{28}
12844	390	7	{32}
12845	390	8	{38}
12846	390	9	{45}
12847	390	10	{51,55,49}
12848	390	11	{60}
12849	390	12	{64}
12850	390	13	{69}
12851	390	14	{75}
12852	390	15	{79}
12853	390	16	{83}
12854	390	17	{90}
12855	390	18	{95}
12856	390	19	{99}
12857	390	20	{103}
12858	390	21	{110}
12859	390	22	{114}
12860	390	23	{119}
12861	390	24	{125}
12862	390	25	{129}
12863	390	26	{133,136,137}
12864	390	27	{140}
12865	390	28	{146}
12866	390	29	{152}
12867	390	30	{160}
12868	390	31	{163,166,162}
12869	390	32	{172}
12870	390	33	{179,174,173}
12871	391	1	{4}
12872	391	2	{8}
12873	391	3	{11}
12874	391	4	{18}
12875	391	5	{23}
12876	391	6	{28}
12877	391	7	{32}
12878	391	8	{39}
12879	391	9	{47}
12880	391	10	{50,49}
12881	391	11	{59}
12882	391	12	{64}
12883	391	13	{69}
12884	391	14	{74}
12885	391	15	{78}
12886	391	16	{84}
12887	391	17	{89}
12888	391	18	{94}
12889	391	19	{99}
12890	391	20	{104}
12891	391	21	{110}
12892	391	22	{114}
12893	391	23	{119}
12894	391	24	{124}
12895	391	25	{129}
12896	391	26	{132,135}
12897	391	27	{142}
12898	391	28	{146}
12899	391	29	{148,150,154}
12900	391	30	{156}
12901	391	31	{161,165}
12902	391	32	{170}
12903	391	33	{178,173}
12904	392	1	{3}
12905	392	2	{8}
12906	392	3	{13}
12907	392	4	{18}
12908	392	5	{23}
12909	392	6	{29}
12910	392	7	{32}
12911	392	8	{39}
12912	392	9	{42}
12913	392	10	{56,49}
12914	392	11	{59}
12915	392	12	{64}
12916	392	13	{69}
12917	392	14	{73}
12918	392	15	{79}
12919	392	16	{83}
12920	392	17	{89}
12921	392	18	{95}
12922	392	19	{99}
12923	392	20	{104}
12924	392	21	{110}
12925	392	22	{115}
12926	392	23	{120}
12927	392	24	{124}
12928	392	25	{129}
12929	392	26	{133,132}
12930	392	27	{140}
12931	392	28	{145}
12932	392	29	{149}
12933	392	30	{157}
12934	392	31	{167,166,169}
12935	392	32	{170}
12936	392	33	{176}
12937	393	1	{3}
12938	393	2	{9}
12939	393	3	{11}
12940	393	4	{18}
12941	393	5	{23}
12942	393	6	{28}
12943	393	7	{33}
12944	393	8	{39}
12945	393	9	{41,47}
12946	393	10	{51,56,49}
12947	393	11	{60}
12948	393	12	{64}
12949	393	13	{69}
12950	393	14	{74}
12951	393	15	{80}
12952	393	16	{83}
12953	393	17	{90}
12954	393	18	{94}
12955	393	19	{99}
12956	393	20	{104}
12957	393	21	{110}
12958	393	22	{115}
12959	393	23	{118}
12960	393	24	{124}
12961	393	25	{129}
12962	393	26	{133,135,134}
12963	393	27	{141}
12964	393	28	{145}
12965	393	29	{154}
12966	393	30	{158}
12967	393	31	{165}
12968	393	32	{172}
12969	393	33	{178,176,177}
12970	394	1	{2}
12971	394	2	{8}
12972	394	3	{13}
12973	394	4	{19}
12974	394	5	{24}
12975	394	6	{27}
12976	394	7	{35}
12977	394	8	{38}
12978	394	9	{46,45}
12979	394	10	{50,56,49}
12980	394	11	{58}
12981	394	12	{64}
12982	394	13	{69}
12983	394	14	{74}
12984	394	15	{78}
12985	394	16	{84}
12986	394	17	{88}
12987	394	18	{94}
12988	394	19	{99}
12989	394	20	{105}
12990	394	21	{110}
12991	394	22	{113}
12992	394	23	{119}
12993	394	24	{124}
12994	394	25	{129}
12995	394	26	{133,134,137}
12996	394	27	{140}
12997	394	28	{144}
12998	394	29	{151,152,150}
12999	394	30	{157}
13000	394	31	{165}
13001	394	32	{172}
13002	394	33	{178,176,173}
13003	395	1	{3}
13004	395	2	{8}
13005	395	3	{13}
13006	395	4	{17}
13007	395	5	{23}
13008	395	6	{28}
13009	395	7	{33}
13010	395	8	{37}
13011	395	9	{42,46,44}
13012	395	10	{51,49}
13013	395	11	{59}
13014	395	12	{64}
13015	395	13	{69}
13016	395	14	{74}
13017	395	15	{79}
13018	395	16	{84}
13019	395	17	{89}
13020	395	18	{94}
13021	395	19	{97}
13022	395	20	{102}
13023	395	21	{110}
13024	395	22	{114}
13025	395	23	{119}
13026	395	24	{124}
13027	395	25	{129}
13028	395	26	{137}
13029	395	27	{142}
13030	395	28	{145}
13031	395	29	{153,150,155}
13032	395	30	{156}
13033	395	31	{168,162}
13034	395	32	{171}
13035	395	33	{180,175,177}
13036	396	1	{3}
13037	396	2	{8}
13038	396	3	{13}
13039	396	4	{18}
13040	396	5	{23}
13041	396	6	{28}
13042	396	7	{33}
13043	396	8	{38}
13044	396	9	{42,44}
13045	396	10	{55}
13046	396	11	{59}
13047	396	12	{64}
13048	396	13	{69}
13049	396	14	{72}
13050	396	15	{78}
13051	396	16	{84}
13052	396	17	{89}
13053	396	18	{95}
13054	396	19	{99}
13055	396	20	{104}
13056	396	21	{110}
13057	396	22	{114}
13058	396	23	{119}
13059	396	24	{125}
13060	396	25	{130}
13061	396	26	{135,136}
13062	396	27	{140}
13063	396	28	{145}
13064	396	29	{152,155}
13065	396	30	{160}
13066	396	31	{168,164}
13067	396	32	{171}
13068	396	33	{179,180,177}
13069	397	1	{4}
13070	397	2	{9}
13071	397	3	{12}
13072	397	4	{17}
13073	397	5	{22}
13074	397	6	{26}
13075	397	7	{33}
13076	397	8	{38}
13077	397	9	{42,46}
13078	397	10	{54}
13079	397	11	{60}
13080	397	12	{64}
13081	397	13	{69}
13082	397	14	{74}
13083	397	15	{79}
13084	397	16	{84}
13085	397	17	{89}
13086	397	18	{95}
13087	397	19	{99}
13088	397	20	{105}
13089	397	21	{110}
13090	397	22	{114}
13091	397	23	{119}
13092	397	24	{124}
13093	397	25	{130}
13094	397	26	{134}
13095	397	27	{140}
13096	397	28	{144}
13097	397	29	{151,150}
13098	397	30	{160}
13099	397	31	{163,161}
13100	397	32	{172}
13101	397	33	{176,180,174}
13102	398	1	{3}
13103	398	2	{6}
13104	398	3	{13}
13105	398	4	{18}
13106	398	5	{23}
13107	398	6	{28}
13108	398	7	{33}
13109	398	8	{37}
13110	398	9	{46,43}
13111	398	10	{53}
13112	398	11	{59}
13113	398	12	{64}
13114	398	13	{69}
13115	398	14	{74}
13116	398	15	{79}
13117	398	16	{84}
13118	398	17	{89}
13119	398	18	{93}
13120	398	19	{99}
13121	398	20	{103}
13122	398	21	{109}
13123	398	22	{113}
13124	398	23	{119}
13125	398	24	{124}
13126	398	25	{130}
13127	398	26	{132,137}
13128	398	27	{140}
13129	398	28	{145}
13130	398	29	{152,154}
13131	398	30	{160}
13132	398	31	{166,161,162}
13133	398	32	{172}
13134	398	33	{181,177}
13135	399	1	{3}
13136	399	2	{7}
13137	399	3	{14}
13138	399	4	{16}
13139	399	5	{22}
13140	399	6	{30}
13141	399	7	{33}
13142	399	8	{38}
13143	399	9	{48}
13144	399	10	{53,51,49}
13145	399	11	{59}
13146	399	12	{62}
13147	399	13	{70}
13148	399	14	{73}
13149	399	15	{79}
13150	399	16	{84}
13151	399	17	{90}
13152	399	18	{94}
13153	399	19	{99}
13154	399	20	{104}
13155	399	21	{110}
13156	399	22	{114}
13157	399	23	{120}
13158	399	24	{126}
13159	399	25	{129}
13160	399	26	{132,135}
13161	399	27	{139}
13162	399	28	{145}
13163	399	29	{148}
13164	399	30	{157}
13165	399	31	{163,161,165}
13166	399	32	{172}
13167	399	33	{180,173}
13168	400	1	{3}
13169	400	2	{8}
13170	400	3	{13}
13171	400	4	{18}
13172	400	5	{24}
13173	400	6	{28}
13174	400	7	{33}
13175	400	8	{39}
13176	400	9	{42,45}
13177	400	10	{51,49}
13178	400	11	{60}
13179	400	12	{65}
13180	400	13	{69}
13181	400	14	{74}
13182	400	15	{81}
13183	400	16	{85}
13184	400	17	{88}
13185	400	18	{94}
13186	400	19	{98}
13187	400	20	{104}
13188	400	21	{109}
13189	400	22	{114}
13190	400	23	{119}
13191	400	24	{124}
13192	400	25	{130}
13193	400	26	{133,132,136}
13194	400	27	{140}
13195	400	28	{144}
13196	400	29	{153,154}
13197	400	30	{157}
13198	400	31	{167}
13199	400	32	{170}
13200	400	33	{181,175,173}
13201	401	1	{2}
13202	401	2	{8}
13203	401	3	{12}
13204	401	4	{18}
13205	401	5	{23}
13206	401	6	{29}
13207	401	7	{34}
13208	401	8	{38}
13209	401	9	{48,44}
13210	401	10	{50,51}
13211	401	11	{59}
13212	401	12	{64}
13213	401	13	{69}
13214	401	14	{74}
13215	401	15	{80}
13216	401	16	{84}
13217	401	17	{90}
13218	401	18	{94}
13219	401	19	{99}
13220	401	20	{102}
13221	401	21	{111}
13222	401	22	{113}
13223	401	23	{120}
13224	401	24	{125}
13225	401	25	{129}
13226	401	26	{133,136,137}
13227	401	27	{140}
13228	401	28	{145}
13229	401	29	{152}
13230	401	30	{159}
13231	401	31	{163,165,164}
13232	401	32	{170}
13233	401	33	{175,177}
13234	402	1	{3}
13235	402	2	{8}
13236	402	3	{13}
13237	402	4	{16}
13238	402	5	{22}
13239	402	6	{28}
13240	402	7	{33}
13241	402	8	{38}
13242	402	9	{48}
13243	402	10	{55,56}
13244	402	11	{59}
13245	402	12	{63}
13246	402	13	{68}
13247	402	14	{74}
13248	402	15	{80}
13249	402	16	{85}
13250	402	17	{88}
13251	402	18	{94}
13252	402	19	{99}
13253	402	20	{105}
13254	402	21	{111}
13255	402	22	{114}
13256	402	23	{119}
13257	402	24	{124}
13258	402	25	{129}
13259	402	26	{132,134}
13260	402	27	{140}
13261	402	28	{145}
13262	402	29	{148}
13263	402	30	{160}
13264	402	31	{164}
13265	402	32	{171}
13266	402	33	{178,179}
13267	403	1	{3}
13268	403	2	{8}
13269	403	3	{12}
13270	403	4	{19}
13271	403	5	{23}
13272	403	6	{28}
13273	403	7	{33}
13274	403	8	{38}
13275	403	9	{47}
13276	403	10	{53}
13277	403	11	{59}
13278	403	12	{64}
13279	403	13	{69}
13280	403	14	{74}
13281	403	15	{79}
13282	403	16	{83}
13283	403	17	{89}
13284	403	18	{94}
13285	403	19	{97}
13286	403	20	{103}
13287	403	21	{110}
13288	403	22	{113}
13289	403	23	{119}
13290	403	24	{125}
13291	403	25	{128}
13292	403	26	{132,135}
13293	403	27	{140}
13294	403	28	{146}
13295	403	29	{151,152,149}
13296	403	30	{157}
13297	403	31	{161}
13298	403	32	{172}
13299	403	33	{178,174}
13300	404	1	{3}
13301	404	2	{8}
13302	404	3	{13}
13303	404	4	{19}
13304	404	5	{21}
13305	404	6	{29}
13306	404	7	{33}
13307	404	8	{38}
13308	404	9	{48,46,47}
13309	404	10	{55,52}
13310	404	11	{59}
13311	404	12	{64}
13312	404	13	{69}
13313	404	14	{74}
13314	404	15	{80}
13315	404	16	{83}
13316	404	17	{89}
13317	404	18	{94}
13318	404	19	{99}
13319	404	20	{104}
13320	404	21	{111}
13321	404	22	{114}
13322	404	23	{119}
13323	404	24	{124}
13324	404	25	{129}
13325	404	26	{137}
13326	404	27	{138}
13327	404	28	{146}
13328	404	29	{148,154,155}
13329	404	30	{157}
13330	404	31	{165}
13331	404	32	{170}
13332	404	33	{179,177}
13333	405	1	{3}
13334	405	2	{9}
13335	405	3	{13}
13336	405	4	{18}
13337	405	5	{23}
13338	405	6	{28}
13339	405	7	{34}
13340	405	8	{38}
13341	405	9	{43}
13342	405	10	{56}
13343	405	11	{59}
13344	405	12	{63}
13345	405	13	{70}
13346	405	14	{74}
13347	405	15	{79}
13348	405	16	{83}
13349	405	17	{89}
13350	405	18	{94}
13351	405	19	{100}
13352	405	20	{104}
13353	405	21	{110}
13354	405	22	{113}
13355	405	23	{119}
13356	405	24	{125}
13357	405	25	{128}
13358	405	26	{137}
13359	405	27	{140}
13360	405	28	{145}
13361	405	29	{153,150,155}
13362	405	30	{160}
13363	405	31	{167,161,165}
13364	405	32	{171}
13365	405	33	{181,176,175}
13366	406	1	{2}
13367	406	2	{8}
13368	406	3	{13}
13369	406	4	{18}
13370	406	5	{22}
13371	406	6	{28}
13372	406	7	{32}
13373	406	8	{38}
13374	406	9	{48,41}
13375	406	10	{56}
13376	406	11	{61}
13377	406	12	{64}
13378	406	13	{69}
13379	406	14	{74}
13380	406	15	{78}
13381	406	16	{84}
13382	406	17	{88}
13383	406	18	{94}
13384	406	19	{99}
13385	406	20	{104}
13386	406	21	{111}
13387	406	22	{114}
13388	406	23	{121}
13389	406	24	{125}
13390	406	25	{128}
13391	406	26	{133,136,137}
13392	406	27	{141}
13393	406	28	{145}
13394	406	29	{153,152,154}
13395	406	30	{158}
13396	406	31	{169}
13397	406	32	{172}
13398	406	33	{176,175,174}
13399	407	1	{3}
13400	407	2	{8}
13401	407	3	{13}
13402	407	4	{18}
13403	407	5	{23}
13404	407	6	{28}
13405	407	7	{33}
13406	407	8	{38}
13407	407	9	{41}
13408	407	10	{52}
13409	407	11	{59}
13410	407	12	{64}
13411	407	13	{68}
13412	407	14	{74}
13413	407	15	{80}
13414	407	16	{85}
13415	407	17	{89}
13416	407	18	{92}
13417	407	19	{99}
13418	407	20	{103}
13419	407	21	{110}
13420	407	22	{114}
13421	407	23	{118}
13422	407	24	{124}
13423	407	25	{129}
13424	407	26	{133}
13425	407	27	{140}
13426	407	28	{146}
13427	407	29	{148,152,149}
13428	407	30	{159}
13429	407	31	{168,165}
13430	407	32	{170}
13431	407	33	{178,180,173}
13432	408	1	{4}
13433	408	2	{10}
13434	408	3	{13}
13435	408	4	{18}
13436	408	5	{23}
13437	408	6	{29}
13438	408	7	{31}
13439	408	8	{38}
13440	408	9	{48,43,41}
13441	408	10	{54,53,49}
13442	408	11	{59}
13443	408	12	{65}
13444	408	13	{71}
13445	408	14	{74}
13446	408	15	{79}
13447	408	16	{84}
13448	408	17	{89}
13449	408	18	{94}
13450	408	19	{98}
13451	408	20	{105}
13452	408	21	{110}
13453	408	22	{116}
13454	408	23	{119}
13455	408	24	{124}
13456	408	25	{128}
13457	408	26	{133,136,137}
13458	408	27	{140}
13459	408	28	{144}
13460	408	29	{148,153,149}
13461	408	30	{156}
13462	408	31	{165}
13463	408	32	{171}
13464	408	33	{176,175,177}
13465	409	1	{2}
13466	409	2	{7}
13467	409	3	{13}
13468	409	4	{18}
13469	409	5	{23}
13470	409	6	{29}
13471	409	7	{33}
13472	409	8	{38}
13473	409	9	{41}
13474	409	10	{54,52}
13475	409	11	{60}
13476	409	12	{64}
13477	409	13	{69}
13478	409	14	{74}
13479	409	15	{81}
13480	409	16	{84}
13481	409	17	{90}
13482	409	18	{94}
13483	409	19	{99}
13484	409	20	{104}
13485	409	21	{110}
13486	409	22	{114}
13487	409	23	{119}
13488	409	24	{123}
13489	409	25	{129}
13490	409	26	{133,137}
13491	409	27	{140}
13492	409	28	{145}
13493	409	29	{152,155}
13494	409	30	{159}
13495	409	31	{162}
13496	409	32	{172}
13497	409	33	{180,177}
13498	410	1	{4}
13499	410	2	{8}
13500	410	3	{14}
13501	410	4	{18}
13502	410	5	{22}
13503	410	6	{28}
13504	410	7	{33}
13505	410	8	{39}
13506	410	9	{43,41}
13507	410	10	{53,51,55}
13508	410	11	{58}
13509	410	12	{64}
13510	410	13	{69}
13511	410	14	{74}
13512	410	15	{79}
13513	410	16	{85}
13514	410	17	{88}
13515	410	18	{94}
13516	410	19	{98}
13517	410	20	{103}
13518	410	21	{110}
13519	410	22	{115}
13520	410	23	{119}
13521	410	24	{124}
13522	410	25	{129}
13523	410	26	{133,132}
13524	410	27	{140}
13525	410	28	{145}
13526	410	29	{152}
13527	410	30	{158}
13528	410	31	{161}
13529	410	32	{170}
13530	410	33	{176,174,177}
13531	411	1	{3}
13532	411	2	{9}
13533	411	3	{14}
13534	411	4	{18}
13535	411	5	{23}
13536	411	6	{27}
13537	411	7	{33}
13538	411	8	{39}
13539	411	9	{42,43,47}
13540	411	10	{50}
13541	411	11	{58}
13542	411	12	{65}
13543	411	13	{69}
13544	411	14	{72}
13545	411	15	{79}
13546	411	16	{86}
13547	411	17	{89}
13548	411	18	{95}
13549	411	19	{98}
13550	411	20	{104}
13551	411	21	{110}
13552	411	22	{112}
13553	411	23	{119}
13554	411	24	{123}
13555	411	25	{130}
13556	411	26	{133}
13557	411	27	{139}
13558	411	28	{145}
13559	411	29	{153,154,155}
13560	411	30	{159}
13561	411	31	{163,167}
13562	411	32	{170}
13563	411	33	{179,181,175}
13564	412	1	{4}
13565	412	2	{8}
13566	412	3	{12}
13567	412	4	{18}
13568	412	5	{23}
13569	412	6	{28}
13570	412	7	{34}
13571	412	8	{38}
13572	412	9	{42,48,47}
13573	412	10	{50,51,49}
13574	412	11	{59}
13575	412	12	{64}
13576	412	13	{69}
13577	412	14	{73}
13578	412	15	{79}
13579	412	16	{85}
13580	412	17	{89}
13581	412	18	{94}
13582	412	19	{100}
13583	412	20	{104}
13584	412	21	{109}
13585	412	22	{114}
13586	412	23	{119}
13587	412	24	{124}
13588	412	25	{128}
13589	412	26	{132,134,136}
13590	412	27	{140}
13591	412	28	{144}
13592	412	29	{151,152,155}
13593	412	30	{160}
13594	412	31	{163,165,169}
13595	412	32	{171}
13596	412	33	{178,174}
13597	413	1	{4}
13598	413	2	{8}
13599	413	3	{13}
13600	413	4	{18}
13601	413	5	{23}
13602	413	6	{28}
13603	413	7	{33}
13604	413	8	{38}
13605	413	9	{46,43}
13606	413	10	{56}
13607	413	11	{60}
13608	413	12	{65}
13609	413	13	{69}
13610	413	14	{74}
13611	413	15	{79}
13612	413	16	{84}
13613	413	17	{89}
13614	413	18	{94}
13615	413	19	{100}
13616	413	20	{106}
13617	413	21	{110}
13618	413	22	{113}
13619	413	23	{117}
13620	413	24	{124}
13621	413	25	{129}
13622	413	26	{134}
13623	413	27	{141}
13624	413	28	{146}
13625	413	29	{148,150}
13626	413	30	{157}
13627	413	31	{163,169,164}
13628	413	32	{171}
13629	413	33	{178,177,173}
13630	414	1	{2}
13631	414	2	{8}
13632	414	3	{13}
13633	414	4	{18}
13634	414	5	{23}
13635	414	6	{27}
13636	414	7	{33}
13637	414	8	{37}
13638	414	9	{42,45}
13639	414	10	{53,56,49}
13640	414	11	{59}
13641	414	12	{64}
13642	414	13	{70}
13643	414	14	{74}
13644	414	15	{79}
13645	414	16	{84}
13646	414	17	{89}
13647	414	18	{94}
13648	414	19	{99}
13649	414	20	{104}
13650	414	21	{108}
13651	414	22	{115}
13652	414	23	{119}
13653	414	24	{125}
13654	414	25	{128}
13655	414	26	{135,134,137}
13656	414	27	{139}
13657	414	28	{145}
13658	414	29	{151}
13659	414	30	{156}
13660	414	31	{164}
13661	414	32	{172}
13662	414	33	{174}
13663	415	1	{3}
13664	415	2	{10}
13665	415	3	{13}
13666	415	4	{18}
13667	415	5	{23}
13668	415	6	{28}
13669	415	7	{33}
13670	415	8	{36}
13671	415	9	{42,41}
13672	415	10	{53,56}
13673	415	11	{61}
13674	415	12	{62}
13675	415	13	{69}
13676	415	14	{74}
13677	415	15	{79}
13678	415	16	{83}
13679	415	17	{90}
13680	415	18	{94}
13681	415	19	{100}
13682	415	20	{105}
13683	415	21	{110}
13684	415	22	{114}
13685	415	23	{119}
13686	415	24	{125}
13687	415	25	{129}
13688	415	26	{135,134,136}
13689	415	27	{141}
13690	415	28	{145}
13691	415	29	{148,150,149}
13692	415	30	{157}
13693	415	31	{163,168,162}
13694	415	32	{171}
13695	415	33	{179,176,173}
13696	416	1	{2}
13697	416	2	{7}
13698	416	3	{13}
13699	416	4	{19}
13700	416	5	{24}
13701	416	6	{29}
13702	416	7	{33}
13703	416	8	{38}
13704	416	9	{42,48,46}
13705	416	10	{56}
13706	416	11	{59}
13707	416	12	{65}
13708	416	13	{69}
13709	416	14	{74}
13710	416	15	{78}
13711	416	16	{83}
13712	416	17	{89}
13713	416	18	{93}
13714	416	19	{99}
13715	416	20	{105}
13716	416	21	{110}
13717	416	22	{114}
13718	416	23	{119}
13719	416	24	{125}
13720	416	25	{129}
13721	416	26	{132,136,137}
13722	416	27	{140}
13723	416	28	{146}
13724	416	29	{149}
13725	416	30	{159}
13726	416	31	{168,161,164}
13727	416	32	{171}
13728	416	33	{176}
13729	417	1	{2}
13730	417	2	{9}
13731	417	3	{12}
13732	417	4	{18}
13733	417	5	{23}
13734	417	6	{28}
13735	417	7	{33}
13736	417	8	{38}
13737	417	9	{48,46,43}
13738	417	10	{56}
13739	417	11	{60}
13740	417	12	{64}
13741	417	13	{69}
13742	417	14	{74}
13743	417	15	{79}
13744	417	16	{85}
13745	417	17	{90}
13746	417	18	{94}
13747	417	19	{100}
13748	417	20	{103}
13749	417	21	{109}
13750	417	22	{114}
13751	417	23	{119}
13752	417	24	{124}
13753	417	25	{129}
13754	417	26	{132,136}
13755	417	27	{139}
13756	417	28	{145}
13757	417	29	{151,150}
13758	417	30	{160}
13759	417	31	{165}
13760	417	32	{170}
13761	417	33	{181}
13762	418	1	{2}
13763	418	2	{10}
13764	418	3	{13}
13765	418	4	{18}
13766	418	5	{23}
13767	418	6	{29}
13768	418	7	{33}
13769	418	8	{37}
13770	418	9	{42,48,44}
13771	418	10	{54}
13772	418	11	{59}
13773	418	12	{64}
13774	418	13	{70}
13775	418	14	{74}
13776	418	15	{79}
13777	418	16	{85}
13778	418	17	{89}
13779	418	18	{93}
13780	418	19	{99}
13781	418	20	{104}
13782	418	21	{110}
13783	418	22	{114}
13784	418	23	{119}
13785	418	24	{124}
13786	418	25	{129}
13787	418	26	{133,134,136}
13788	418	27	{139}
13789	418	28	{145}
13790	418	29	{148,154}
13791	418	30	{158}
13792	418	31	{161,169}
13793	418	32	{171}
13794	418	33	{180}
13795	419	1	{5}
13796	419	2	{7}
13797	419	3	{13}
13798	419	4	{18}
13799	419	5	{22}
13800	419	6	{28}
13801	419	7	{34}
13802	419	8	{38}
13803	419	9	{44}
13804	419	10	{54,56}
13805	419	11	{59}
13806	419	12	{64}
13807	419	13	{69}
13808	419	14	{75}
13809	419	15	{78}
13810	419	16	{85}
13811	419	17	{88}
13812	419	18	{95}
13813	419	19	{99}
13814	419	20	{104}
13815	419	21	{110}
13816	419	22	{114}
13817	419	23	{120}
13818	419	24	{124}
13819	419	25	{128}
13820	419	26	{135,134,137}
13821	419	27	{141}
13822	419	28	{146}
13823	419	29	{153,152}
13824	419	30	{156}
13825	419	31	{161,162}
13826	419	32	{171}
13827	419	33	{178,174,173}
13828	420	1	{3}
13829	420	2	{8}
13830	420	3	{13}
13831	420	4	{18}
13832	420	5	{25}
13833	420	6	{28}
13834	420	7	{32}
13835	420	8	{38}
13836	420	9	{43}
13837	420	10	{56,52}
13838	420	11	{59}
13839	420	12	{63}
13840	420	13	{69}
13841	420	14	{73}
13842	420	15	{78}
13843	420	16	{84}
13844	420	17	{91}
13845	420	18	{94}
13846	420	19	{99}
13847	420	20	{104}
13848	420	21	{110}
13849	420	22	{114}
13850	420	23	{119}
13851	420	24	{124}
13852	420	25	{131}
13853	420	26	{134}
13854	420	27	{139}
13855	420	28	{145}
13856	420	29	{151,153}
13857	420	30	{156}
13858	420	31	{163,161,165}
13859	420	32	{171}
13860	420	33	{174,177}
13861	421	1	{3}
13862	421	2	{9}
13863	421	3	{13}
13864	421	4	{18}
13865	421	5	{22}
13866	421	6	{28}
13867	421	7	{33}
13868	421	8	{40}
13869	421	9	{48,46}
13870	421	10	{54,55,49}
13871	421	11	{59}
13872	421	12	{64}
13873	421	13	{70}
13874	421	14	{74}
13875	421	15	{78}
13876	421	16	{83}
13877	421	17	{89}
13878	421	18	{94}
13879	421	19	{99}
13880	421	20	{105}
13881	421	21	{110}
13882	421	22	{115}
13883	421	23	{119}
13884	421	24	{122}
13885	421	25	{128}
13886	421	26	{134,137}
13887	421	27	{140}
13888	421	28	{145}
13889	421	29	{155}
13890	421	30	{160}
13891	421	31	{168,165}
13892	421	32	{172}
13893	421	33	{178}
13894	422	1	{3}
13895	422	2	{8}
13896	422	3	{13}
13897	422	4	{17}
13898	422	5	{23}
13899	422	6	{28}
13900	422	7	{33}
13901	422	8	{36}
13902	422	9	{48}
13903	422	10	{51}
13904	422	11	{58}
13905	422	12	{64}
13906	422	13	{68}
13907	422	14	{72}
13908	422	15	{80}
13909	422	16	{85}
13910	422	17	{90}
13911	422	18	{93}
13912	422	19	{98}
13913	422	20	{104}
13914	422	21	{111}
13915	422	22	{114}
13916	422	23	{118}
13917	422	24	{124}
13918	422	25	{129}
13919	422	26	{133}
13920	422	27	{141}
13921	422	28	{145}
13922	422	29	{151,148,149}
13923	422	30	{156}
13924	422	31	{163,167,169}
13925	422	32	{170}
13926	422	33	{180,173}
13927	423	1	{3}
13928	423	2	{8}
13929	423	3	{13}
13930	423	4	{18}
13931	423	5	{23}
13932	423	6	{28}
13933	423	7	{33}
13934	423	8	{38}
13935	423	9	{43}
13936	423	10	{53,49}
13937	423	11	{59}
13938	423	12	{65}
13939	423	13	{69}
13940	423	14	{74}
13941	423	15	{79}
13942	423	16	{84}
13943	423	17	{89}
13944	423	18	{94}
13945	423	19	{99}
13946	423	20	{105}
13947	423	21	{110}
13948	423	22	{114}
13949	423	23	{120}
13950	423	24	{124}
13951	423	25	{130}
13952	423	26	{137}
13953	423	27	{140}
13954	423	28	{146}
13955	423	29	{153,152,155}
13956	423	30	{158}
13957	423	31	{167,161,169}
13958	423	32	{170}
13959	423	33	{176}
13960	424	1	{4}
13961	424	2	{8}
13962	424	3	{13}
13963	424	4	{18}
13964	424	5	{22}
13965	424	6	{28}
13966	424	7	{33}
13967	424	8	{37}
13968	424	9	{48,46,44}
13969	424	10	{56}
13970	424	11	{59}
13971	424	12	{64}
13972	424	13	{69}
13973	424	14	{74}
13974	424	15	{79}
13975	424	16	{84}
13976	424	17	{89}
13977	424	18	{94}
13978	424	19	{98}
13979	424	20	{103}
13980	424	21	{111}
13981	424	22	{113}
13982	424	23	{119}
13983	424	24	{123}
13984	424	25	{129}
13985	424	26	{132,135,137}
13986	424	27	{139}
13987	424	28	{146}
13988	424	29	{148,150,149}
13989	424	30	{159}
13990	424	31	{167,164}
13991	424	32	{172}
13992	424	33	{178,173}
13993	425	1	{3}
13994	425	2	{10}
13995	425	3	{13}
13996	425	4	{17}
13997	425	5	{23}
13998	425	6	{28}
13999	425	7	{32}
14000	425	8	{39}
14001	425	9	{42,44,45}
14002	425	10	{52}
14003	425	11	{60}
14004	425	12	{64}
14005	425	13	{69}
14006	425	14	{74}
14007	425	15	{79}
14008	425	16	{84}
14009	425	17	{89}
14010	425	18	{93}
14011	425	19	{100}
14012	425	20	{105}
14013	425	21	{110}
14014	425	22	{115}
14015	425	23	{119}
14016	425	24	{123}
14017	425	25	{129}
14018	425	26	{135,134,137}
14019	425	27	{138}
14020	425	28	{143}
14021	425	29	{150,149,154}
14022	425	30	{158}
14023	425	31	{167,164}
14024	425	32	{170}
14025	425	33	{181,175}
14026	426	1	{4}
14027	426	2	{9}
14028	426	3	{13}
14029	426	4	{17}
14030	426	5	{23}
14031	426	6	{30}
14032	426	7	{34}
14033	426	8	{39}
14034	426	9	{46,43,47}
14035	426	10	{54,50,51,52}
14036	426	11	{60}
14037	426	12	{65}
14038	426	13	{67}
14039	426	14	{72}
14040	426	15	{79}
14041	426	16	{86}
14042	426	17	{90}
14043	426	18	{95}
14044	426	19	{101}
14045	426	20	{105}
14046	426	21	{111}
14047	426	22	{116}
14048	426	23	{120}
14049	426	24	{125}
14050	426	25	{130}
14051	426	26	{135,137}
14052	426	27	{141}
14053	426	28	{147}
14054	426	29	{151,153,152,155}
14055	426	30	{157}
14056	426	31	{163,167,161}
14057	426	32	{170}
14058	426	33	{178,179,176,174}
14059	427	1	{4}
14060	427	2	{9}
14061	427	3	{15}
14062	427	4	{19}
14063	427	5	{24}
14064	427	6	{29}
14065	427	7	{35}
14066	427	8	{39}
14067	427	9	{42,43}
14068	427	10	{54,53,49}
14069	427	11	{60}
14070	427	12	{64}
14071	427	13	{69}
14072	427	14	{76}
14073	427	15	{79}
14074	427	16	{85}
14075	427	17	{90}
14076	427	18	{95}
14077	427	19	{101}
14078	427	20	{105}
14079	427	21	{110}
14080	427	22	{115}
14081	427	23	{121}
14082	427	24	{125}
14083	427	25	{131}
14084	427	26	{134,136}
14085	427	27	{141}
14086	427	28	{145}
14087	427	29	{149,154,155}
14088	427	30	{159}
14089	427	31	{168,162,165,164}
14090	427	32	{170}
14091	427	33	{178,176,175}
14092	428	1	{4}
14093	428	2	{9}
14094	428	3	{14}
14095	428	4	{18}
14096	428	5	{24}
14097	428	6	{29}
14098	428	7	{35}
14099	428	8	{39}
14100	428	9	{42,44,43}
14101	428	10	{53,55,52}
14102	428	11	{60}
14103	428	12	{65}
14104	428	13	{71}
14105	428	14	{75}
14106	428	15	{80}
14107	428	16	{85}
14108	428	17	{90}
14109	428	18	{95}
14110	428	19	{100}
14111	428	20	{104}
14112	428	21	{111}
14113	428	22	{115}
14114	428	23	{121}
14115	428	24	{126}
14116	428	25	{131}
14117	428	26	{135,134,136,137}
14118	428	27	{142}
14119	428	28	{145}
14120	428	29	{152,150,154}
14121	428	30	{156}
14122	428	31	{166,161}
14123	428	32	{170}
14124	428	33	{178,176,174,177}
14125	429	1	{4}
14126	429	2	{10}
14127	429	3	{13}
14128	429	4	{19}
14129	429	5	{22}
14130	429	6	{29}
14131	429	7	{34}
14132	429	8	{39}
14133	429	9	{48,46}
14134	429	10	{50,56,49}
14135	429	11	{60}
14136	429	12	{64}
14137	429	13	{70}
14138	429	14	{74}
14139	429	15	{80}
14140	429	16	{85}
14141	429	17	{89}
14142	429	18	{94}
14143	429	19	{100}
14144	429	20	{105}
14145	429	21	{111}
14146	429	22	{112}
14147	429	23	{120}
14148	429	24	{125}
14149	429	25	{129}
14150	429	26	{133,135,136,137}
14151	429	27	{141}
14152	429	28	{145}
14153	429	29	{151,153}
14154	429	30	{159}
14155	429	31	{163,168,162}
14156	429	32	{170}
14157	429	33	{178,180,174,173}
14158	430	1	{4}
14159	430	2	{9}
14160	430	3	{14}
14161	430	4	{20}
14162	430	5	{23}
14163	430	6	{28}
14164	430	7	{32}
14165	430	8	{39}
14166	430	9	{42,48,47,45}
14167	430	10	{54,50,56,49}
14168	430	11	{60}
14169	430	12	{65}
14170	430	13	{70}
14171	430	14	{74}
14172	430	15	{80}
14173	430	16	{85}
14174	430	17	{89}
14175	430	18	{95}
14176	430	19	{99}
14177	430	20	{104}
14178	430	21	{111}
14179	430	22	{115}
14180	430	23	{121}
14181	430	24	{125}
14182	430	25	{130}
14183	430	26	{133,135,136,137}
14184	430	27	{140}
14185	430	28	{146}
14186	430	29	{148,153,152,149}
14187	430	30	{160}
14188	430	31	{161,165,164}
14189	430	32	{170}
14190	430	33	{178,180,177}
14191	431	1	{4}
14192	431	2	{9}
14193	431	3	{15}
14194	431	4	{19}
14195	431	5	{25}
14196	431	6	{29}
14197	431	7	{34}
14198	431	8	{40}
14199	431	9	{46,43,47,45}
14200	431	10	{56,49,52}
14201	431	11	{60}
14202	431	12	{63}
14203	431	13	{70}
14204	431	14	{75}
14205	431	15	{81}
14206	431	16	{85}
14207	431	17	{91}
14208	431	18	{94}
14209	431	19	{99}
14210	431	20	{106}
14211	431	21	{111}
14212	431	22	{115}
14213	431	23	{121}
14214	431	24	{125}
14215	431	25	{130}
14216	431	26	{132,135,137}
14217	431	27	{141}
14218	431	28	{146}
14219	431	29	{148,152,149,155}
14220	431	30	{157}
14221	431	31	{163,168,164}
14222	431	32	{171}
14223	431	33	{178,175,174}
14224	432	1	{4}
14225	432	2	{9}
14226	432	3	{14}
14227	432	4	{19}
14228	432	5	{24}
14229	432	6	{29}
14230	432	7	{34}
14231	432	8	{38}
14232	432	9	{42,48,47}
14233	432	10	{53,49}
14234	432	11	{60}
14235	432	12	{65}
14236	432	13	{71}
14237	432	14	{75}
14238	432	15	{80}
14239	432	16	{85}
14240	432	17	{90}
14241	432	18	{94}
14242	432	19	{100}
14243	432	20	{105}
14244	432	21	{111}
14245	432	22	{115}
14246	432	23	{120}
14247	432	24	{125}
14248	432	25	{128}
14249	432	26	{132,134,136,137}
14250	432	27	{141}
14251	432	28	{146}
14252	432	29	{151,152,149}
14253	432	30	{156}
14254	432	31	{163,167}
14255	432	32	{170}
14256	432	33	{178,179,181}
14257	433	1	{4}
14258	433	2	{9}
14259	433	3	{14}
14260	433	4	{19}
14261	433	5	{24}
14262	433	6	{29}
14263	433	7	{34}
14264	433	8	{40}
14265	433	9	{48,45}
14266	433	10	{50,51,49,52}
14267	433	11	{60}
14268	433	12	{65}
14269	433	13	{70}
14270	433	14	{75}
14271	433	15	{80}
14272	433	16	{85}
14273	433	17	{89}
14274	433	18	{96}
14275	433	19	{98}
14276	433	20	{105}
14277	433	21	{111}
14278	433	22	{115}
14279	433	23	{119}
14280	433	24	{125}
14281	433	25	{130}
14282	433	26	{134,137}
14283	433	27	{141}
14284	433	28	{147}
14285	433	29	{153,152,155}
14286	433	30	{158}
14287	433	31	{162,169}
14288	433	32	{171}
14289	433	33	{181,176,177,173}
14290	434	1	{3}
14291	434	2	{10}
14292	434	3	{14}
14293	434	4	{20}
14294	434	5	{24}
14295	434	6	{29}
14296	434	7	{34}
14297	434	8	{39}
14298	434	9	{44,47}
14299	434	10	{56,52}
14300	434	11	{60}
14301	434	12	{65}
14302	434	13	{69}
14303	434	14	{74}
14304	434	15	{79}
14305	434	16	{85}
14306	434	17	{90}
14307	434	18	{96}
14308	434	19	{100}
14309	434	20	{104}
14310	434	21	{110}
14311	434	22	{115}
14312	434	23	{120}
14313	434	24	{124}
14314	434	25	{130}
14315	434	26	{136,137}
14316	434	27	{141}
14317	434	28	{146}
14318	434	29	{152,155}
14319	434	30	{158}
14320	434	31	{163,166,161}
14321	434	32	{170}
14322	434	33	{178,180,174,177}
14323	435	1	{2}
14324	435	2	{10}
14325	435	3	{15}
14326	435	4	{19}
14327	435	5	{24}
14328	435	6	{28}
14329	435	7	{34}
14330	435	8	{38}
14331	435	9	{48,41,47}
14332	435	10	{54,51,56}
14333	435	11	{60}
14334	435	12	{64}
14335	435	13	{70}
14336	435	14	{75}
14337	435	15	{79}
14338	435	16	{86}
14339	435	17	{90}
14340	435	18	{96}
14341	435	19	{100}
14342	435	20	{105}
14343	435	21	{111}
14344	435	22	{114}
14345	435	23	{120}
14346	435	24	{125}
14347	435	25	{131}
14348	435	26	{133,135,136}
14349	435	27	{141}
14350	435	28	{146}
14351	435	29	{153,150,154,155}
14352	435	30	{157}
14353	435	31	{163,166,165,164}
14354	435	32	{172}
14355	435	33	{181,176,177}
14356	436	1	{5}
14357	436	2	{9}
14358	436	3	{13}
14359	436	4	{19}
14360	436	5	{24}
14361	436	6	{30}
14362	436	7	{34}
14363	436	8	{39}
14364	436	9	{48,46,44,41}
14365	436	10	{56,52}
14366	436	11	{59}
14367	436	12	{64}
14368	436	13	{70}
14369	436	14	{74}
14370	436	15	{80}
14371	436	16	{85}
14372	436	17	{89}
14373	436	18	{95}
14374	436	19	{100}
14375	436	20	{105}
14376	436	21	{111}
14377	436	22	{115}
14378	436	23	{118}
14379	436	24	{125}
14380	436	25	{130}
14381	436	26	{132,135,136}
14382	436	27	{141}
14383	436	28	{147}
14384	436	29	{148,153,150}
14385	436	30	{158}
14386	436	31	{163,166,164}
14387	436	32	{170}
14388	436	33	{181,175,177}
14389	437	1	{4}
14390	437	2	{8}
14391	437	3	{14}
14392	437	4	{19}
14393	437	5	{24}
14394	437	6	{29}
14395	437	7	{32}
14396	437	8	{39}
14397	437	9	{46,47}
14398	437	10	{50,51,49}
14399	437	11	{60}
14400	437	12	{65}
14401	437	13	{71}
14402	437	14	{76}
14403	437	15	{80}
14404	437	16	{86}
14405	437	17	{90}
14406	437	18	{95}
14407	437	19	{100}
14408	437	20	{105}
14409	437	21	{111}
14410	437	22	{116}
14411	437	23	{121}
14412	437	24	{125}
14413	437	25	{129}
14414	437	26	{132,135,136}
14415	437	27	{141}
14416	437	28	{146}
14417	437	29	{150,149}
14418	437	30	{158}
14419	437	31	{166,161,162,164}
14420	437	32	{170}
14421	437	33	{179,175,173}
14422	438	1	{4}
14423	438	2	{9}
14424	438	3	{14}
14425	438	4	{19}
14426	438	5	{22}
14427	438	6	{29}
14428	438	7	{33}
14429	438	8	{39}
14430	438	9	{42,44,43}
14431	438	10	{54,51,49}
14432	438	11	{60}
14433	438	12	{66}
14434	438	13	{70}
14435	438	14	{75}
14436	438	15	{80}
14437	438	16	{84}
14438	438	17	{90}
14439	438	18	{95}
14440	438	19	{100}
14441	438	20	{105}
14442	438	21	{111}
14443	438	22	{116}
14444	438	23	{120}
14445	438	24	{125}
14446	438	25	{130}
14447	438	26	{132,135,134,136}
14448	438	27	{141}
14449	438	28	{146}
14450	438	29	{151,152,149,154}
14451	438	30	{159}
14452	438	31	{161,165,169}
14453	438	32	{170}
14454	438	33	{179,174}
14455	439	1	{5}
14456	439	2	{9}
14457	439	3	{14}
14458	439	4	{19}
14459	439	5	{23}
14460	439	6	{29}
14461	439	7	{35}
14462	439	8	{38}
14463	439	9	{43,45}
14464	439	10	{54,53,51,52}
14465	439	11	{61}
14466	439	12	{66}
14467	439	13	{70}
14468	439	14	{75}
14469	439	15	{80}
14470	439	16	{82}
14471	439	17	{90}
14472	439	18	{94}
14473	439	19	{100}
14474	439	20	{106}
14475	439	21	{110}
14476	439	22	{113}
14477	439	23	{120}
14478	439	24	{125}
14479	439	25	{130}
14480	439	26	{133,132,134,136}
14481	439	27	{141}
14482	439	28	{145}
14483	439	29	{153,150,154}
14484	439	30	{160}
14485	439	31	{167,161,162}
14486	439	32	{171}
14487	439	33	{178,177}
14488	440	1	{2}
14489	440	2	{8}
14490	440	3	{14}
14491	440	4	{19}
14492	440	5	{24}
14493	440	6	{28}
14494	440	7	{34}
14495	440	8	{38}
14496	440	9	{46,44}
14497	440	10	{50,51}
14498	440	11	{60}
14499	440	12	{65}
14500	440	13	{71}
14501	440	14	{75}
14502	440	15	{79}
14503	440	16	{82}
14504	440	17	{90}
14505	440	18	{95}
14506	440	19	{100}
14507	440	20	{105}
14508	440	21	{111}
14509	440	22	{115}
14510	440	23	{120}
14511	440	24	{125}
14512	440	25	{129}
14513	440	26	{133,135,134}
14514	440	27	{141}
14515	440	28	{146}
14516	440	29	{151,148,152,154}
14517	440	30	{158}
14518	440	31	{163,168,162}
14519	440	32	{170}
14520	440	33	{180,175,174}
14521	441	1	{4}
14522	441	2	{9}
14523	441	3	{14}
14524	441	4	{18}
14525	441	5	{23}
14526	441	6	{29}
14527	441	7	{34}
14528	441	8	{39}
14529	441	9	{43,41,47}
14530	441	10	{53,52}
14531	441	11	{60}
14532	441	12	{65}
14533	441	13	{70}
14534	441	14	{76}
14535	441	15	{79}
14536	441	16	{85}
14537	441	17	{90}
14538	441	18	{95}
14539	441	19	{100}
14540	441	20	{104}
14541	441	21	{110}
14542	441	22	{114}
14543	441	23	{120}
14544	441	24	{124}
14545	441	25	{131}
14546	441	26	{133,134}
14547	441	27	{141}
14548	441	28	{147}
14549	441	29	{151,150,155}
14550	441	30	{159}
14551	441	31	{163,161,162}
14552	441	32	{172}
14553	441	33	{179,176,177}
14554	442	1	{1}
14555	442	2	{9}
14556	442	3	{14}
14557	442	4	{17}
14558	442	5	{24}
14559	442	6	{28}
14560	442	7	{34}
14561	442	8	{39}
14562	442	9	{42,48,41,47}
14563	442	10	{51,55,52}
14564	442	11	{60}
14565	442	12	{65}
14566	442	13	{70}
14567	442	14	{75}
14568	442	15	{79}
14569	442	16	{86}
14570	442	17	{90}
14571	442	18	{95}
14572	442	19	{101}
14573	442	20	{105}
14574	442	21	{110}
14575	442	22	{115}
14576	442	23	{121}
14577	442	24	{122}
14578	442	25	{130}
14579	442	26	{132,136}
14580	442	27	{141}
14581	442	28	{145}
14582	442	29	{154,155}
14583	442	30	{156}
14584	442	31	{167,161,162,169}
14585	442	32	{171}
14586	442	33	{179,176,175,177}
14587	443	1	{4}
14588	443	2	{9}
14589	443	3	{13}
14590	443	4	{16}
14591	443	5	{24}
14592	443	6	{29}
14593	443	7	{35}
14594	443	8	{40}
14595	443	9	{42,46,44,41}
14596	443	10	{50,56,49}
14597	443	11	{60}
14598	443	12	{65}
14599	443	13	{68}
14600	443	14	{75}
14601	443	15	{80}
14602	443	16	{86}
14603	443	17	{89}
14604	443	18	{93}
14605	443	19	{100}
14606	443	20	{106}
14607	443	21	{111}
14608	443	22	{115}
14609	443	23	{120}
14610	443	24	{125}
14611	443	25	{131}
14612	443	26	{135,134,136}
14613	443	27	{141}
14614	443	28	{145}
14615	443	29	{151,152,149,154}
14616	443	30	{159}
14617	443	31	{161,165}
14618	443	32	{171}
14619	443	33	{178,173}
14620	444	1	{3}
14621	444	2	{8}
14622	444	3	{15}
14623	444	4	{20}
14624	444	5	{24}
14625	444	6	{29}
14626	444	7	{34}
14627	444	8	{40}
14628	444	9	{46,47,45}
14629	444	10	{54,50,51,55}
14630	444	11	{60}
14631	444	12	{65}
14632	444	13	{70}
14633	444	14	{75}
14634	444	15	{79}
14635	444	16	{85}
14636	444	17	{89}
14637	444	18	{96}
14638	444	19	{99}
14639	444	20	{106}
14640	444	21	{110}
14641	444	22	{116}
14642	444	23	{119}
14643	444	24	{124}
14644	444	25	{129}
14645	444	26	{135,136,137}
14646	444	27	{141}
14647	444	28	{146}
14648	444	29	{151,154}
14649	444	30	{157}
14650	444	31	{162,165}
14651	444	32	{170}
14652	444	33	{180,177}
14653	445	1	{5}
14654	445	2	{10}
14655	445	3	{15}
14656	445	4	{20}
14657	445	5	{23}
14658	445	6	{27}
14659	445	7	{32}
14660	445	8	{39}
14661	445	9	{48,44,47}
14662	445	10	{53,56}
14663	445	11	{60}
14664	445	12	{64}
14665	445	13	{69}
14666	445	14	{75}
14667	445	15	{80}
14668	445	16	{86}
14669	445	17	{90}
14670	445	18	{95}
14671	445	19	{101}
14672	445	20	{104}
14673	445	21	{111}
14674	445	22	{114}
14675	445	23	{120}
14676	445	24	{125}
14677	445	25	{131}
14678	445	26	{132,136}
14679	445	27	{141}
14680	445	28	{146}
14681	445	29	{153,150,154,155}
14682	445	30	{160}
14683	445	31	{166,162}
14684	445	32	{171}
14685	445	33	{178,181,176,175}
14686	446	1	{3}
14687	446	2	{9}
14688	446	3	{12}
14689	446	4	{19}
14690	446	5	{24}
14691	446	6	{26}
14692	446	7	{35}
14693	446	8	{39}
14694	446	9	{41,47}
14695	446	10	{55,56,49,52}
14696	446	11	{60}
14697	446	12	{66}
14698	446	13	{71}
14699	446	14	{75}
14700	446	15	{81}
14701	446	16	{85}
14702	446	17	{89}
14703	446	18	{96}
14704	446	19	{99}
14705	446	20	{105}
14706	446	21	{110}
14707	446	22	{115}
14708	446	23	{120}
14709	446	24	{125}
14710	446	25	{129}
14711	446	26	{133,132,135,134}
14712	446	27	{141}
14713	446	28	{144}
14714	446	29	{151,153,152,149}
14715	446	30	{159}
14716	446	31	{167,166,164}
14717	446	32	{172}
14718	446	33	{179,181,173}
14719	447	1	{4}
14720	447	2	{8}
14721	447	3	{14}
14722	447	4	{19}
14723	447	5	{24}
14724	447	6	{27}
14725	447	7	{34}
14726	447	8	{39}
14727	447	9	{48,43}
14728	447	10	{53,51,55,49}
14729	447	11	{60}
14730	447	12	{65}
14731	447	13	{71}
14732	447	14	{72}
14733	447	15	{80}
14734	447	16	{85}
14735	447	17	{89}
14736	447	18	{94}
14737	447	19	{100}
14738	447	20	{105}
14739	447	21	{109}
14740	447	22	{115}
14741	447	23	{121}
14742	447	24	{124}
14743	447	25	{130}
14744	447	26	{133,132,135,137}
14745	447	27	{141}
14746	447	28	{146}
14747	447	29	{151,150,154,155}
14748	447	30	{158}
14749	447	31	{163,167}
14750	447	32	{172}
14751	447	33	{179,176}
14752	448	1	{4}
14753	448	2	{9}
14754	448	3	{14}
14755	448	4	{19}
14756	448	5	{24}
14757	448	6	{28}
14758	448	7	{35}
14759	448	8	{40}
14760	448	9	{42,48,46}
14761	448	10	{54,51}
14762	448	11	{59}
14763	448	12	{65}
14764	448	13	{71}
14765	448	14	{75}
14766	448	15	{80}
14767	448	16	{85}
14768	448	17	{90}
14769	448	18	{95}
14770	448	19	{100}
14771	448	20	{105}
14772	448	21	{110}
14773	448	22	{115}
14774	448	23	{120}
14775	448	24	{125}
14776	448	25	{129}
14777	448	26	{135,134,136,137}
14778	448	27	{141}
14779	448	28	{146}
14780	448	29	{152,155}
14781	448	30	{156}
14782	448	31	{166,168,161,169}
14783	448	32	{170}
14784	448	33	{180,174,177}
14785	449	1	{4}
14786	449	2	{9}
14787	449	3	{14}
14788	449	4	{18}
14789	449	5	{24}
14790	449	6	{30}
14791	449	7	{34}
14792	449	8	{39}
14793	449	9	{48,46,45}
14794	449	10	{53,49}
14795	449	11	{60}
14796	449	12	{66}
14797	449	13	{71}
14798	449	14	{75}
14799	449	15	{80}
14800	449	16	{85}
14801	449	17	{91}
14802	449	18	{95}
14803	449	19	{100}
14804	449	20	{105}
14805	449	21	{111}
14806	449	22	{115}
14807	449	23	{119}
14808	449	24	{125}
14809	449	25	{130}
14810	449	26	{132,136,137}
14811	449	27	{141}
14812	449	28	{146}
14813	449	29	{151,148,153,152}
14814	449	30	{156}
14815	449	31	{168,165}
14816	449	32	{171}
14817	449	33	{179,180}
14818	450	1	{4}
14819	450	2	{9}
14820	450	3	{14}
14821	450	4	{19}
14822	450	5	{24}
14823	450	6	{27}
14824	450	7	{33}
14825	450	8	{38}
14826	450	9	{44,43}
14827	450	10	{53,51}
14828	450	11	{60}
14829	450	12	{65}
14830	450	13	{70}
14831	450	14	{75}
14832	450	15	{80}
14833	450	16	{85}
14834	450	17	{90}
14835	450	18	{95}
14836	450	19	{100}
14837	450	20	{104}
14838	450	21	{110}
14839	450	22	{115}
14840	450	23	{118}
14841	450	24	{124}
14842	450	25	{130}
14843	450	26	{135,136}
14844	450	27	{141}
14845	450	28	{146}
14846	450	29	{148,152,150,155}
14847	450	30	{157}
14848	450	31	{163,168,164}
14849	450	32	{171}
14850	450	33	{178,181,180,177}
14851	451	1	{5}
14852	451	2	{10}
14853	451	3	{14}
14854	451	4	{20}
14855	451	5	{24}
14856	451	6	{30}
14857	451	7	{34}
14858	451	8	{39}
14859	451	9	{46,41}
14860	451	10	{53,50,51,55}
14861	451	11	{60}
14862	451	12	{65}
14863	451	13	{70}
14864	451	14	{76}
14865	451	15	{81}
14866	451	16	{85}
14867	451	17	{90}
14868	451	18	{94}
14869	451	19	{99}
14870	451	20	{103}
14871	451	21	{111}
14872	451	22	{115}
14873	451	23	{120}
14874	451	24	{124}
14875	451	25	{128}
14876	451	26	{134,137}
14877	451	27	{142}
14878	451	28	{146}
14879	451	29	{152,150,149,154}
14880	451	30	{157}
14881	451	31	{163,164}
14882	451	32	{170}
14883	451	33	{179,176,174,177}
14884	452	1	{5}
14885	452	2	{8}
14886	452	3	{14}
14887	452	4	{19}
14888	452	5	{23}
14889	452	6	{29}
14890	452	7	{35}
14891	452	8	{39}
14892	452	9	{43,47}
14893	452	10	{50,51,55,56}
14894	452	11	{61}
14895	452	12	{65}
14896	452	13	{68}
14897	452	14	{75}
14898	452	15	{80}
14899	452	16	{85}
14900	452	17	{90}
14901	452	18	{95}
14902	452	19	{99}
14903	452	20	{105}
14904	452	21	{111}
14905	452	22	{115}
14906	452	23	{120}
14907	452	24	{123}
14908	452	25	{130}
14909	452	26	{133,135}
14910	452	27	{141}
14911	452	28	{146}
14912	452	29	{148,149}
14913	452	30	{157}
14914	452	31	{166,168,165}
14915	452	32	{170}
14916	452	33	{179,181,180,174}
14917	453	1	{4}
14918	453	2	{9}
14919	453	3	{14}
14920	453	4	{20}
14921	453	5	{23}
14922	453	6	{30}
14923	453	7	{34}
14924	453	8	{40}
14925	453	9	{42,46,43,47}
14926	453	10	{54,53,55,52}
14927	453	11	{60}
14928	453	12	{65}
14929	453	13	{70}
14930	453	14	{75}
14931	453	15	{80}
14932	453	16	{84}
14933	453	17	{90}
14934	453	18	{96}
14935	453	19	{101}
14936	453	20	{104}
14937	453	21	{111}
14938	453	22	{114}
14939	453	23	{121}
14940	453	24	{125}
14941	453	25	{130}
14942	453	26	{133,137}
14943	453	27	{141}
14944	453	28	{145}
14945	453	29	{152,149,154}
14946	453	30	{160}
14947	453	31	{163,166,165}
14948	453	32	{170}
14949	453	33	{181,180,175}
14950	454	1	{5}
14951	454	2	{9}
14952	454	3	{14}
14953	454	4	{20}
14954	454	5	{23}
14955	454	6	{29}
14956	454	7	{34}
14957	454	8	{39}
14958	454	9	{43,41,47}
14959	454	10	{53,51,49}
14960	454	11	{60}
14961	454	12	{65}
14962	454	13	{70}
14963	454	14	{76}
14964	454	15	{81}
14965	454	16	{85}
14966	454	17	{90}
14967	454	18	{93}
14968	454	19	{101}
14969	454	20	{105}
14970	454	21	{111}
14971	454	22	{116}
14972	454	23	{120}
14973	454	24	{124}
14974	454	25	{130}
14975	454	26	{132,136,137}
14976	454	27	{141}
14977	454	28	{145}
14978	454	29	{151,148,149,155}
14979	454	30	{156}
14980	454	31	{163,167,168,161}
14981	454	32	{170}
14982	454	33	{176,175,173}
14983	455	1	{3}
14984	455	2	{9}
14985	455	3	{15}
14986	455	4	{20}
14987	455	5	{24}
14988	455	6	{26}
14989	455	7	{31}
14990	455	8	{38}
14991	455	9	{48,43}
14992	455	10	{54,53,51,49}
14993	455	11	{60}
14994	455	12	{62}
14995	455	13	{70}
14996	455	14	{76}
14997	455	15	{80}
14998	455	16	{82}
14999	455	17	{90}
15000	455	18	{95}
15001	455	19	{98}
15002	455	20	{104}
15003	455	21	{111}
15004	455	22	{114}
15005	455	23	{121}
15006	455	24	{124}
15007	455	25	{130}
15008	455	26	{135,134}
15009	455	27	{138}
15010	455	28	{146}
15011	455	29	{151,152,150}
15012	455	30	{156}
15013	455	31	{166,161}
15014	455	32	{171}
15015	455	33	{176,173}
15016	456	1	{4}
15017	456	2	{9}
15018	456	3	{13}
15019	456	4	{18}
15020	456	5	{24}
15021	456	6	{29}
15022	456	7	{34}
15023	456	8	{39}
15024	456	9	{48,46,44}
15025	456	10	{53,49}
15026	456	11	{61}
15027	456	12	{63}
15028	456	13	{69}
15029	456	14	{76}
15030	456	15	{81}
15031	456	16	{86}
15032	456	17	{90}
15033	456	18	{95}
15034	456	19	{100}
15035	456	20	{105}
15036	456	21	{110}
15037	456	22	{115}
15038	456	23	{121}
15039	456	24	{125}
15040	456	25	{130}
15041	456	26	{133,132,136}
15042	456	27	{141}
15043	456	28	{146}
15044	456	29	{148,152}
15045	456	30	{157}
15046	456	31	{163,167,169,164}
15047	456	32	{170}
15048	456	33	{181,175,177}
15049	457	1	{3}
15050	457	2	{8}
15051	457	3	{14}
15052	457	4	{19}
15053	457	5	{24}
15054	457	6	{29}
15055	457	7	{35}
15056	457	8	{39}
15057	457	9	{42,46,47,45}
15058	457	10	{53,55}
15059	457	11	{60}
15060	457	12	{65}
15061	457	13	{71}
15062	457	14	{75}
15063	457	15	{81}
15064	457	16	{85}
15065	457	17	{90}
15066	457	18	{95}
15067	457	19	{100}
15068	457	20	{105}
15069	457	21	{108}
15070	457	22	{115}
15071	457	23	{119}
15072	457	24	{125}
15073	457	25	{130}
15074	457	26	{132,134,137}
15075	457	27	{142}
15076	457	28	{145}
15077	457	29	{151,148,153,155}
15078	457	30	{159}
15079	457	31	{161,165,169}
15080	457	32	{172}
15081	457	33	{179,176,175,173}
15082	458	1	{5}
15083	458	2	{8}
15084	458	3	{14}
15085	458	4	{19}
15086	458	5	{24}
15087	458	6	{29}
15088	458	7	{34}
15089	458	8	{39}
15090	458	9	{42,46,43,47}
15091	458	10	{50,55,49}
15092	458	11	{60}
15093	458	12	{66}
15094	458	13	{70}
15095	458	14	{75}
15096	458	15	{80}
15097	458	16	{85}
15098	458	17	{90}
15099	458	18	{95}
15100	458	19	{100}
15101	458	20	{105}
15102	458	21	{111}
15103	458	22	{115}
15104	458	23	{120}
15105	458	24	{125}
15106	458	25	{130}
15107	458	26	{133,135,134,137}
15108	458	27	{141}
15109	458	28	{146}
15110	458	29	{151,153,150,149}
15111	458	30	{160}
15112	458	31	{167,165,164}
15113	458	32	{170}
15114	458	33	{179,181,180}
15115	459	1	{4}
15116	459	2	{9}
15117	459	3	{14}
15118	459	4	{18}
15119	459	5	{24}
15120	459	6	{29}
15121	459	7	{35}
15122	459	8	{39}
15123	459	9	{48,44}
15124	459	10	{54,49}
15125	459	11	{61}
15126	459	12	{65}
15127	459	13	{70}
15128	459	14	{75}
15129	459	15	{80}
15130	459	16	{85}
15131	459	17	{90}
15132	459	18	{93}
15133	459	19	{100}
15134	459	20	{105}
15135	459	21	{110}
15136	459	22	{115}
15137	459	23	{120}
15138	459	24	{126}
15139	459	25	{130}
15140	459	26	{132,135,134,137}
15141	459	27	{141}
15142	459	28	{146}
15143	459	29	{151,149}
15144	459	30	{158}
15145	459	31	{163,162,169,164}
15146	459	32	{170}
15147	459	33	{179,181,177}
15148	460	1	{5}
15149	460	2	{8}
15150	460	3	{11}
15151	460	4	{19}
15152	460	5	{24}
15153	460	6	{30}
15154	460	7	{34}
15155	460	8	{40}
15156	460	9	{43,47,45}
15157	460	10	{50,55,56,52}
15158	460	11	{60}
15159	460	12	{65}
15160	460	13	{69}
15161	460	14	{75}
15162	460	15	{80}
15163	460	16	{85}
15164	460	17	{91}
15165	460	18	{94}
15166	460	19	{101}
15167	460	20	{105}
15168	460	21	{111}
15169	460	22	{112}
15170	460	23	{120}
15171	460	24	{124}
15172	460	25	{130}
15173	460	26	{133,135,134,137}
15174	460	27	{142}
15175	460	28	{146}
15176	460	29	{151,148,154}
15177	460	30	{156}
15178	460	31	{166,162,164}
15179	460	32	{171}
15180	460	33	{181,176,177,173}
15181	461	1	{5}
15182	461	2	{9}
15183	461	3	{14}
15184	461	4	{19}
15185	461	5	{24}
15186	461	6	{30}
15187	461	7	{34}
15188	461	8	{37}
15189	461	9	{48,47}
15190	461	10	{51,55,56}
15191	461	11	{61}
15192	461	12	{66}
15193	461	13	{69}
15194	461	14	{74}
15195	461	15	{79}
15196	461	16	{85}
15197	461	17	{90}
15198	461	18	{96}
15199	461	19	{101}
15200	461	20	{105}
15201	461	21	{111}
15202	461	22	{115}
15203	461	23	{121}
15204	461	24	{125}
15205	461	25	{131}
15206	461	26	{133,135}
15207	461	27	{140}
15208	461	28	{146}
15209	461	29	{154,155}
15210	461	30	{157}
15211	461	31	{168,162,169,164}
15212	461	32	{172}
15213	461	33	{175,174}
15214	462	1	{3}
15215	462	2	{8}
15216	462	3	{14}
15217	462	4	{19}
15218	462	5	{21}
15219	462	6	{29}
15220	462	7	{35}
15221	462	8	{39}
15222	462	9	{42,48,44,47}
15223	462	10	{50,51,55,52}
15224	462	11	{59}
15225	462	12	{65}
15226	462	13	{71}
15227	462	14	{75}
15228	462	15	{80}
15229	462	16	{86}
15230	462	17	{90}
15231	462	18	{94}
15232	462	19	{100}
15233	462	20	{105}
15234	462	21	{110}
15235	462	22	{115}
15236	462	23	{121}
15237	462	24	{125}
15238	462	25	{130}
15239	462	26	{133,132,135,134}
15240	462	27	{141}
15241	462	28	{147}
15242	462	29	{148,153}
15243	462	30	{158}
15244	462	31	{163,166}
15245	462	32	{171}
15246	462	33	{181,175,174}
15247	463	1	{3}
15248	463	2	{9}
15249	463	3	{14}
15250	463	4	{18}
15251	463	5	{24}
15252	463	6	{29}
15253	463	7	{34}
15254	463	8	{39}
15255	463	9	{42,41}
15256	463	10	{50,51,56,52}
15257	463	11	{60}
15258	463	12	{64}
15259	463	13	{69}
15260	463	14	{75}
15261	463	15	{80}
15262	463	16	{86}
15263	463	17	{89}
15264	463	18	{95}
15265	463	19	{99}
15266	463	20	{106}
15267	463	21	{108}
15268	463	22	{116}
15269	463	23	{121}
15270	463	24	{125}
15271	463	25	{131}
15272	463	26	{132,135,134}
15273	463	27	{140}
15274	463	28	{146}
15275	463	29	{148,153,150,155}
15276	463	30	{157}
15277	463	31	{167,161,165,169}
15278	463	32	{171}
15279	463	33	{178,173}
15280	464	1	{5}
15281	464	2	{9}
15282	464	3	{15}
15283	464	4	{19}
15284	464	5	{24}
15285	464	6	{29}
15286	464	7	{34}
15287	464	8	{40}
15288	464	9	{42,48,44,45}
15289	464	10	{54,51}
15290	464	11	{60}
15291	464	12	{65}
15292	464	13	{70}
15293	464	14	{75}
15294	464	15	{80}
15295	464	16	{84}
15296	464	17	{91}
15297	464	18	{95}
15298	464	19	{101}
15299	464	20	{105}
15300	464	21	{111}
15301	464	22	{115}
15302	464	23	{121}
15303	464	24	{125}
15304	464	25	{130}
15305	464	26	{133,136}
15306	464	27	{140}
15307	464	28	{146}
15308	464	29	{151,153,154,155}
15309	464	30	{157}
15310	464	31	{161,169,164}
15311	464	32	{171}
15312	464	33	{180,177}
15313	465	1	{4}
15314	465	2	{8}
15315	465	3	{14}
15316	465	4	{19}
15317	465	5	{25}
15318	465	6	{30}
15319	465	7	{35}
15320	465	8	{40}
15321	465	9	{44,43}
15322	465	10	{54,50,55}
15323	465	11	{60}
15324	465	12	{66}
15325	465	13	{70}
15326	465	14	{75}
15327	465	15	{80}
15328	465	16	{85}
15329	465	17	{90}
15330	465	18	{95}
15331	465	19	{101}
15332	465	20	{104}
15333	465	21	{111}
15334	465	22	{114}
15335	465	23	{119}
15336	465	24	{125}
15337	465	25	{130}
15338	465	26	{133,132,134,136}
15339	465	27	{141}
15340	465	28	{146}
15341	465	29	{151,153,149,154}
15342	465	30	{158}
15343	465	31	{163,168}
15344	465	32	{172}
15345	465	33	{178,181,175,174}
15346	466	1	{4}
15347	466	2	{9}
15348	466	3	{14}
15349	466	4	{19}
15350	466	5	{24}
15351	466	6	{29}
15352	466	7	{33}
15353	466	8	{39}
15354	466	9	{46,41,47}
15355	466	10	{50,51,56,52}
15356	466	11	{60}
15357	466	12	{65}
15358	466	13	{68}
15359	466	14	{75}
15360	466	15	{80}
15361	466	16	{85}
15362	466	17	{90}
15363	466	18	{96}
15364	466	19	{100}
15365	466	20	{105}
15366	466	21	{111}
15367	466	22	{115}
15368	466	23	{120}
15369	466	24	{124}
15370	466	25	{129}
15371	466	26	{133,136}
15372	466	27	{140}
15373	466	28	{147}
15374	466	29	{148,153,150,154}
15375	466	30	{158}
15376	466	31	{166,169}
15377	466	32	{170}
15378	466	33	{180,175,177,173}
15379	467	1	{3}
15380	467	2	{9}
15381	467	3	{13}
15382	467	4	{19}
15383	467	5	{24}
15384	467	6	{30}
15385	467	7	{34}
15386	467	8	{39}
15387	467	9	{48,45}
15388	467	10	{51,56}
15389	467	11	{60}
15390	467	12	{65}
15391	467	13	{70}
15392	467	14	{74}
15393	467	15	{80}
15394	467	16	{86}
15395	467	17	{90}
15396	467	18	{95}
15397	467	19	{100}
15398	467	20	{106}
15399	467	21	{111}
15400	467	22	{115}
15401	467	23	{120}
15402	467	24	{125}
15403	467	25	{129}
15404	467	26	{133,135,134,136}
15405	467	27	{141}
15406	467	28	{146}
15407	467	29	{152,150,154,155}
15408	467	30	{158}
15409	467	31	{165,164}
15410	467	32	{170}
15411	467	33	{181,180,175,177}
15412	468	1	{4}
15413	468	2	{10}
15414	468	3	{14}
15415	468	4	{19}
15416	468	5	{25}
15417	468	6	{29}
15418	468	7	{35}
15419	468	8	{39}
15420	468	9	{42,48,47}
15421	468	10	{53,52}
15422	468	11	{60}
15423	468	12	{65}
15424	468	13	{70}
15425	468	14	{75}
15426	468	15	{81}
15427	468	16	{85}
15428	468	17	{89}
15429	468	18	{95}
15430	468	19	{100}
15431	468	20	{105}
15432	468	21	{111}
15433	468	22	{115}
15434	468	23	{121}
15435	468	24	{126}
15436	468	25	{129}
15437	468	26	{136,137}
15438	468	27	{142}
15439	468	28	{146}
15440	468	29	{151,149,155}
15441	468	30	{158}
15442	468	31	{168,162,165}
15443	468	32	{170}
15444	468	33	{180,173}
15445	469	1	{4}
15446	469	2	{9}
15447	469	3	{14}
15448	469	4	{18}
15449	469	5	{24}
15450	469	6	{28}
15451	469	7	{35}
15452	469	8	{38}
15453	469	9	{46,47,45}
15454	469	10	{56,49}
15455	469	11	{60}
15456	469	12	{65}
15457	469	13	{70}
15458	469	14	{75}
15459	469	15	{81}
15460	469	16	{85}
15461	469	17	{90}
15462	469	18	{95}
15463	469	19	{100}
15464	469	20	{105}
15465	469	21	{111}
15466	469	22	{115}
15467	469	23	{120}
15468	469	24	{125}
15469	469	25	{130}
15470	469	26	{133,132,135,137}
15471	469	27	{140}
15472	469	28	{147}
15473	469	29	{152,150}
15474	469	30	{158}
15475	469	31	{166,168,161,162}
15476	469	32	{172}
15477	469	33	{178,181,175,174}
15478	470	1	{4}
15479	470	2	{9}
15480	470	3	{14}
15481	470	4	{18}
15482	470	5	{24}
15483	470	6	{30}
15484	470	7	{34}
15485	470	8	{38}
15486	470	9	{44,47,45}
15487	470	10	{50,56,49,52}
15488	470	11	{60}
15489	470	12	{65}
15490	470	13	{70}
15491	470	14	{75}
15492	470	15	{81}
15493	470	16	{84}
15494	470	17	{91}
15495	470	18	{96}
15496	470	19	{100}
15497	470	20	{106}
15498	470	21	{111}
15499	470	22	{114}
15500	470	23	{121}
15501	470	24	{124}
15502	470	25	{130}
15503	470	26	{133,132,134}
15504	470	27	{142}
15505	470	28	{147}
15506	470	29	{151,153,150}
15507	470	30	{160}
15508	470	31	{167,165,164}
15509	470	32	{170}
15510	470	33	{179,180,175,177}
15511	471	1	{3}
15512	471	2	{9}
15513	471	3	{14}
15514	471	4	{19}
15515	471	5	{24}
15516	471	6	{30}
15517	471	7	{34}
15518	471	8	{39}
15519	471	9	{42,46,44}
15520	471	10	{54,53,49}
15521	471	11	{61}
15522	471	12	{65}
15523	471	13	{71}
15524	471	14	{72}
15525	471	15	{81}
15526	471	16	{84}
15527	471	17	{90}
15528	471	18	{95}
15529	471	19	{100}
15530	471	20	{105}
15531	471	21	{111}
15532	471	22	{115}
15533	471	23	{121}
15534	471	24	{125}
15535	471	25	{130}
15536	471	26	{132,136,137}
15537	471	27	{141}
15538	471	28	{147}
15539	471	29	{153,152,150,155}
15540	471	30	{160}
15541	471	31	{166,168,161,164}
15542	471	32	{172}
15543	471	33	{178,176,173}
15544	472	1	{4}
15545	472	2	{9}
15546	472	3	{14}
15547	472	4	{20}
15548	472	5	{21}
15549	472	6	{29}
15550	472	7	{31}
15551	472	8	{40}
15552	472	9	{43,41,47}
15553	472	10	{54,55,49,52}
15554	472	11	{59}
15555	472	12	{64}
15556	472	13	{67}
15557	472	14	{75}
15558	472	15	{81}
15559	472	16	{85}
15560	472	17	{88}
15561	472	18	{95}
15562	472	19	{100}
15563	472	20	{106}
15564	472	21	{111}
15565	472	22	{116}
15566	472	23	{121}
15567	472	24	{125}
15568	472	25	{127}
15569	472	26	{135,136}
15570	472	27	{141}
15571	472	28	{146}
15572	472	29	{152,150,154,155}
15573	472	30	{160}
15574	472	31	{163,166,168,164}
15575	472	32	{170}
15576	472	33	{175,174}
15577	473	1	{3}
15578	473	2	{9}
15579	473	3	{15}
15580	473	4	{20}
15581	473	5	{24}
15582	473	6	{30}
15583	473	7	{34}
15584	473	8	{37}
15585	473	9	{43,47,45}
15586	473	10	{50,51}
15587	473	11	{60}
15588	473	12	{65}
15589	473	13	{70}
15590	473	14	{73}
15591	473	15	{80}
15592	473	16	{84}
15593	473	17	{89}
15594	473	18	{94}
15595	473	19	{100}
15596	473	20	{105}
15597	473	21	{111}
15598	473	22	{115}
15599	473	23	{119}
15600	473	24	{125}
15601	473	25	{130}
15602	473	26	{132,135,136}
15603	473	27	{141}
15604	473	28	{146}
15605	473	29	{153,152,149}
15606	473	30	{156}
15607	473	31	{167,161}
15608	473	32	{170}
15609	473	33	{180,173}
15610	474	1	{4}
15611	474	2	{9}
15612	474	3	{15}
15613	474	4	{18}
15614	474	5	{24}
15615	474	6	{29}
15616	474	7	{34}
15617	474	8	{39}
15618	474	9	{42,44,41,47}
15619	474	10	{54,51,55}
15620	474	11	{60}
15621	474	12	{66}
15622	474	13	{70}
15623	474	14	{76}
15624	474	15	{80}
15625	474	16	{86}
15626	474	17	{91}
15627	474	18	{95}
15628	474	19	{97}
15629	474	20	{105}
15630	474	21	{111}
15631	474	22	{116}
15632	474	23	{120}
15633	474	24	{125}
15634	474	25	{130}
15635	474	26	{133,135,137}
15636	474	27	{140}
15637	474	28	{145}
15638	474	29	{151,148,154}
15639	474	30	{157}
15640	474	31	{169,164}
15641	474	32	{171}
15642	474	33	{178,176,175,174}
15643	475	1	{1}
15644	475	2	{10}
15645	475	3	{14}
15646	475	4	{20}
15647	475	5	{25}
15648	475	6	{29}
15649	475	7	{33}
15650	475	8	{36}
15651	475	9	{42,46}
15652	475	10	{51,56}
15653	475	11	{61}
15654	475	12	{65}
15655	475	13	{69}
15656	475	14	{75}
15657	475	15	{80}
15658	475	16	{85}
15659	475	17	{91}
15660	475	18	{95}
15661	475	19	{98}
15662	475	20	{103}
15663	475	21	{111}
15664	475	22	{115}
15665	475	23	{120}
15666	475	24	{125}
15667	475	25	{129}
15668	475	26	{134,136}
15669	475	27	{140}
15670	475	28	{146}
15671	475	29	{152,154}
15672	475	30	{157}
15673	475	31	{168,162,165,169}
15674	475	32	{170}
15675	475	33	{178,179,176,177}
15676	476	1	{5}
15677	476	2	{10}
15678	476	3	{15}
15679	476	4	{19}
15680	476	5	{25}
15681	476	6	{26}
15682	476	7	{33}
15683	476	8	{39}
15684	476	9	{48,46,47,45}
15685	476	10	{53,55,56}
15686	476	11	{59}
15687	476	12	{62}
15688	476	13	{71}
15689	476	14	{76}
15690	476	15	{80}
15691	476	16	{85}
15692	476	17	{90}
15693	476	18	{95}
15694	476	19	{101}
15695	476	20	{105}
15696	476	21	{111}
15697	476	22	{115}
15698	476	23	{120}
15699	476	24	{125}
15700	476	25	{131}
15701	476	26	{133,132,136,137}
15702	476	27	{140}
15703	476	28	{145}
15704	476	29	{148,152,154}
15705	476	30	{159}
15706	476	31	{167,166,164}
15707	476	32	{170}
15708	476	33	{176,177}
15709	477	1	{4}
15710	477	2	{9}
15711	477	3	{14}
15712	477	4	{19}
15713	477	5	{24}
15714	477	6	{26}
15715	477	7	{35}
15716	477	8	{39}
15717	477	9	{46,44,43,41}
15718	477	10	{56,52}
15719	477	11	{60}
15720	477	12	{65}
15721	477	13	{70}
15722	477	14	{75}
15723	477	15	{81}
15724	477	16	{85}
15725	477	17	{90}
15726	477	18	{94}
15727	477	19	{101}
15728	477	20	{105}
15729	477	21	{111}
15730	477	22	{115}
15731	477	23	{120}
15732	477	24	{125}
15733	477	25	{130}
15734	477	26	{133,135,134,136}
15735	477	27	{141}
15736	477	28	{146}
15737	477	29	{153,152,154}
15738	477	30	{158}
15739	477	31	{163,167,161,169}
15740	477	32	{172}
15741	477	33	{178,176}
15742	478	1	{3}
15743	478	2	{8}
15744	478	3	{14}
15745	478	4	{18}
15746	478	5	{23}
15747	478	6	{28}
15748	478	7	{35}
15749	478	8	{40}
15750	478	9	{46,43}
15751	478	10	{51,49}
15752	478	11	{60}
15753	478	12	{65}
15754	478	13	{70}
15755	478	14	{74}
15756	478	15	{80}
15757	478	16	{85}
15758	478	17	{90}
15759	478	18	{95}
15760	478	19	{99}
15761	478	20	{105}
15762	478	21	{110}
15763	478	22	{116}
15764	478	23	{120}
15765	478	24	{125}
15766	478	25	{130}
15767	478	26	{133,136,137}
15768	478	27	{142}
15769	478	28	{145}
15770	478	29	{153,149,154}
15771	478	30	{160}
15772	478	31	{166,168,162,165}
15773	478	32	{170}
15774	478	33	{181,176,175}
15775	479	1	{2}
15776	479	2	{7}
15777	479	3	{14}
15778	479	4	{19}
15779	479	5	{24}
15780	479	6	{29}
15781	479	7	{34}
15782	479	8	{40}
15783	479	9	{42,46,47}
15784	479	10	{56,52}
15785	479	11	{60}
15786	479	12	{65}
15787	479	13	{69}
15788	479	14	{75}
15789	479	15	{80}
15790	479	16	{86}
15791	479	17	{90}
15792	479	18	{95}
15793	479	19	{101}
15794	479	20	{106}
15795	479	21	{111}
15796	479	22	{115}
15797	479	23	{120}
15798	479	24	{122}
15799	479	25	{130}
15800	479	26	{133,132,135,134}
15801	479	27	{140}
15802	479	28	{145}
15803	479	29	{151,149}
15804	479	30	{159}
15805	479	31	{168,161,162,165}
15806	479	32	{172}
15807	479	33	{178,179,181,180}
15808	480	1	{4}
15809	480	2	{9}
15810	480	3	{14}
15811	480	4	{20}
15812	480	5	{24}
15813	480	6	{29}
15814	480	7	{34}
15815	480	8	{40}
15816	480	9	{42,48,44,43}
15817	480	10	{54,50,51,49}
15818	480	11	{59}
15819	480	12	{65}
15820	480	13	{70}
15821	480	14	{74}
15822	480	15	{79}
15823	480	16	{85}
15824	480	17	{89}
15825	480	18	{92}
15826	480	19	{101}
15827	480	20	{103}
15828	480	21	{110}
15829	480	22	{115}
15830	480	23	{120}
15831	480	24	{124}
15832	480	25	{130}
15833	480	26	{133,135,136,137}
15834	480	27	{142}
15835	480	28	{146}
15836	480	29	{151,148,149}
15837	480	30	{158}
15838	480	31	{163,169}
15839	480	32	{172}
15840	480	33	{176,180}
15841	481	1	{4}
15842	481	2	{8}
15843	481	3	{14}
15844	481	4	{17}
15845	481	5	{22}
15846	481	6	{29}
15847	481	7	{33}
15848	481	8	{39}
15849	481	9	{48,44,43,47}
15850	481	10	{50,49,52}
15851	481	11	{60}
15852	481	12	{66}
15853	481	13	{70}
15854	481	14	{75}
15855	481	15	{78}
15856	481	16	{85}
15857	481	17	{89}
15858	481	18	{94}
15859	481	19	{100}
15860	481	20	{106}
15861	481	21	{110}
15862	481	22	{115}
15863	481	23	{120}
15864	481	24	{125}
15865	481	25	{127}
15866	481	26	{133,136}
15867	481	27	{140}
15868	481	28	{146}
15869	481	29	{148,154}
15870	481	30	{157}
15871	481	31	{166,168,162,169}
15872	481	32	{170}
15873	481	33	{180,175}
15874	482	1	{4}
15875	482	2	{9}
15876	482	3	{14}
15877	482	4	{19}
15878	482	5	{24}
15879	482	6	{28}
15880	482	7	{34}
15881	482	8	{40}
15882	482	9	{43,41,47,45}
15883	482	10	{56,52}
15884	482	11	{60}
15885	482	12	{66}
15886	482	13	{70}
15887	482	14	{75}
15888	482	15	{80}
15889	482	16	{86}
15890	482	17	{89}
15891	482	18	{95}
15892	482	19	{100}
15893	482	20	{105}
15894	482	21	{111}
15895	482	22	{113}
15896	482	23	{121}
15897	482	24	{125}
15898	482	25	{131}
15899	482	26	{133,135,136,137}
15900	482	27	{142}
15901	482	28	{145}
15902	482	29	{148,150,149,154}
15903	482	30	{159}
15904	482	31	{167,168,162,169}
15905	482	32	{170}
15906	482	33	{175,173}
15907	483	1	{3}
15908	483	2	{9}
15909	483	3	{15}
15910	483	4	{18}
15911	483	5	{24}
15912	483	6	{29}
15913	483	7	{34}
15914	483	8	{36}
15915	483	9	{48,44,47}
15916	483	10	{51,56,52}
15917	483	11	{60}
15918	483	12	{65}
15919	483	13	{70}
15920	483	14	{75}
15921	483	15	{80}
15922	483	16	{85}
15923	483	17	{90}
15924	483	18	{95}
15925	483	19	{100}
15926	483	20	{105}
15927	483	21	{111}
15928	483	22	{116}
15929	483	23	{120}
15930	483	24	{125}
15931	483	25	{130}
15932	483	26	{132,135,136,137}
15933	483	27	{141}
15934	483	28	{146}
15935	483	29	{151,154}
15936	483	30	{159}
15937	483	31	{168,162,164}
15938	483	32	{172}
15939	483	33	{179,181,176,175}
15940	484	1	{4}
15941	484	2	{9}
15942	484	3	{14}
15943	484	4	{19}
15944	484	5	{24}
15945	484	6	{29}
15946	484	7	{33}
15947	484	8	{39}
15948	484	9	{44,47,45}
15949	484	10	{53,50,55}
15950	484	11	{59}
15951	484	12	{64}
15952	484	13	{70}
15953	484	14	{76}
15954	484	15	{80}
15955	484	16	{85}
15956	484	17	{90}
15957	484	18	{94}
15958	484	19	{100}
15959	484	20	{105}
15960	484	21	{111}
15961	484	22	{114}
15962	484	23	{120}
15963	484	24	{125}
15964	484	25	{131}
15965	484	26	{135,134,136}
15966	484	27	{141}
15967	484	28	{146}
15968	484	29	{153,152,150}
15969	484	30	{157}
15970	484	31	{163,168,162}
15971	484	32	{170}
15972	484	33	{179,174,173}
15973	485	1	{4}
15974	485	2	{10}
15975	485	3	{14}
15976	485	4	{19}
15977	485	5	{23}
15978	485	6	{29}
15979	485	7	{34}
15980	485	8	{39}
15981	485	9	{46,44,45}
15982	485	10	{55,56}
15983	485	11	{57}
15984	485	12	{65}
15985	485	13	{70}
15986	485	14	{75}
15987	485	15	{80}
15988	485	16	{82}
15989	485	17	{87}
15990	485	18	{95}
15991	485	19	{101}
15992	485	20	{105}
15993	485	21	{111}
15994	485	22	{115}
15995	485	23	{119}
15996	485	24	{125}
15997	485	25	{130}
15998	485	26	{132,136,137}
15999	485	27	{142}
16000	485	28	{146}
16001	485	29	{151,149}
16002	485	30	{158}
16003	485	31	{163,167,168}
16004	485	32	{170}
16005	485	33	{181,180,174}
16006	486	1	{5}
16007	486	2	{10}
16008	486	3	{15}
16009	486	4	{20}
16010	486	5	{24}
16011	486	6	{30}
16012	486	7	{35}
16013	486	8	{40}
16014	486	9	{44,47}
16015	486	10	{50,51,56,52}
16016	486	11	{61}
16017	486	12	{62}
16018	486	13	{71}
16019	486	14	{75}
16020	486	15	{81}
16021	486	16	{86}
16022	486	17	{91}
16023	486	18	{94}
16024	486	19	{100}
16025	486	20	{106}
16026	486	21	{111}
16027	486	22	{116}
16028	486	23	{120}
16029	486	24	{126}
16030	486	25	{131}
16031	486	26	{132,135,137}
16032	486	27	{141}
16033	486	28	{147}
16034	486	29	{151,152,150}
16035	486	30	{156}
16036	486	31	{162,169,164}
16037	486	32	{171}
16038	486	33	{179,173}
16039	487	1	{5}
16040	487	2	{9}
16041	487	3	{15}
16042	487	4	{20}
16043	487	5	{25}
16044	487	6	{30}
16045	487	7	{35}
16046	487	8	{40}
16047	487	9	{48,47,45}
16048	487	10	{53,50,51}
16049	487	11	{61}
16050	487	12	{65}
16051	487	13	{71}
16052	487	14	{76}
16053	487	15	{81}
16054	487	16	{86}
16055	487	17	{91}
16056	487	18	{96}
16057	487	19	{101}
16058	487	20	{102}
16059	487	21	{111}
16060	487	22	{116}
16061	487	23	{118}
16062	487	24	{125}
16063	487	25	{130}
16064	487	26	{136,137}
16065	487	27	{142}
16066	487	28	{147}
16067	487	29	{148,150,154,155}
16068	487	30	{158}
16069	487	31	{166,161}
16070	487	32	{171}
16071	487	33	{178,175,173}
16072	488	1	{5}
16073	488	2	{10}
16074	488	3	{15}
16075	488	4	{20}
16076	488	5	{25}
16077	488	6	{30}
16078	488	7	{35}
16079	488	8	{39}
16080	488	9	{42,46,43,45}
16081	488	10	{53,55,56,52}
16082	488	11	{60}
16083	488	12	{65}
16084	488	13	{71}
16085	488	14	{76}
16086	488	15	{81}
16087	488	16	{86}
16088	488	17	{90}
16089	488	18	{96}
16090	488	19	{100}
16091	488	20	{106}
16092	488	21	{111}
16093	488	22	{116}
16094	488	23	{121}
16095	488	24	{125}
16096	488	25	{131}
16097	488	26	{133,132,137}
16098	488	27	{142}
16099	488	28	{147}
16100	488	29	{152,150}
16101	488	30	{158}
16102	488	31	{163,167,168,162}
16103	488	32	{171}
16104	488	33	{175,174}
16105	489	1	{5}
16106	489	2	{10}
16107	489	3	{14}
16108	489	4	{20}
16109	489	5	{24}
16110	489	6	{26}
16111	489	7	{35}
16112	489	8	{40}
16113	489	9	{46,47}
16114	489	10	{54,55,49}
16115	489	11	{61}
16116	489	12	{66}
16117	489	13	{71}
16118	489	14	{75}
16119	489	15	{81}
16120	489	16	{86}
16121	489	17	{91}
16122	489	18	{95}
16123	489	19	{98}
16124	489	20	{106}
16125	489	21	{111}
16126	489	22	{116}
16127	489	23	{121}
16128	489	24	{126}
16129	489	25	{131}
16130	489	26	{134,136,137}
16131	489	27	{142}
16132	489	28	{145}
16133	489	29	{148,150}
16134	489	30	{156}
16135	489	31	{167,165}
16136	489	32	{172}
16137	489	33	{176,175,174}
16138	490	1	{5}
16139	490	2	{10}
16140	490	3	{15}
16141	490	4	{20}
16142	490	5	{25}
16143	490	6	{30}
16144	490	7	{35}
16145	490	8	{40}
16146	490	9	{48,44,41}
16147	490	10	{54,51}
16148	490	11	{60}
16149	490	12	{65}
16150	490	13	{71}
16151	490	14	{76}
16152	490	15	{77}
16153	490	16	{86}
16154	490	17	{91}
16155	490	18	{96}
16156	490	19	{101}
16157	490	20	{106}
16158	490	21	{111}
16159	490	22	{116}
16160	490	23	{121}
16161	490	24	{126}
16162	490	25	{131}
16163	490	26	{133,134}
16164	490	27	{142}
16165	490	28	{146}
16166	490	29	{151,148,154}
16167	490	30	{160}
16168	490	31	{163,166,168,162}
16169	490	32	{170}
16170	490	33	{178,177,173}
16171	491	1	{5}
16172	491	2	{9}
16173	491	3	{14}
16174	491	4	{19}
16175	491	5	{25}
16176	491	6	{30}
16177	491	7	{34}
16178	491	8	{40}
16179	491	9	{44,43,45}
16180	491	10	{54,53,51,49}
16181	491	11	{61}
16182	491	12	{65}
16183	491	13	{68}
16184	491	14	{76}
16185	491	15	{81}
16186	491	16	{83}
16187	491	17	{91}
16188	491	18	{93}
16189	491	19	{101}
16190	491	20	{105}
16191	491	21	{111}
16192	491	22	{116}
16193	491	23	{121}
16194	491	24	{123}
16195	491	25	{131}
16196	491	26	{133,135,134,137}
16197	491	27	{142}
16198	491	28	{147}
16199	491	29	{153,154,155}
16200	491	30	{156}
16201	491	31	{161,165}
16202	491	32	{172}
16203	491	33	{178,180,175}
16204	492	1	{4}
16205	492	2	{10}
16206	492	3	{14}
16207	492	4	{20}
16208	492	5	{25}
16209	492	6	{30}
16210	492	7	{34}
16211	492	8	{39}
16212	492	9	{48,46,41,47}
16213	492	10	{51,55,56,49}
16214	492	11	{61}
16215	492	12	{66}
16216	492	13	{69}
16217	492	14	{75}
16218	492	15	{81}
16219	492	16	{82}
16220	492	17	{91}
16221	492	18	{94}
16222	492	19	{99}
16223	492	20	{106}
16224	492	21	{111}
16225	492	22	{116}
16226	492	23	{121}
16227	492	24	{126}
16228	492	25	{131}
16229	492	26	{133,136,137}
16230	492	27	{142}
16231	492	28	{146}
16232	492	29	{151,153,152}
16233	492	30	{156}
16234	492	31	{166,169}
16235	492	32	{172}
16236	492	33	{179,176,174,177}
16237	493	1	{5}
16238	493	2	{10}
16239	493	3	{15}
16240	493	4	{20}
16241	493	5	{21}
16242	493	6	{29}
16243	493	7	{32}
16244	493	8	{39}
16245	493	9	{42,48,43,45}
16246	493	10	{54,50,51}
16247	493	11	{61}
16248	493	12	{66}
16249	493	13	{71}
16250	493	14	{76}
16251	493	15	{81}
16252	493	16	{85}
16253	493	17	{90}
16254	493	18	{96}
16255	493	19	{101}
16256	493	20	{106}
16257	493	21	{111}
16258	493	22	{115}
16259	493	23	{121}
16260	493	24	{126}
16261	493	25	{127}
16262	493	26	{135,136,137}
16263	493	27	{142}
16264	493	28	{147}
16265	493	29	{151,153,154}
16266	493	30	{158}
16267	493	31	{166,168,161,165}
16268	493	32	{172}
16269	493	33	{179,173}
16270	494	1	{5}
16271	494	2	{9}
16272	494	3	{13}
16273	494	4	{20}
16274	494	5	{21}
16275	494	6	{30}
16276	494	7	{35}
16277	494	8	{40}
16278	494	9	{42,48,47,45}
16279	494	10	{54,51,55}
16280	494	11	{61}
16281	494	12	{63}
16282	494	13	{70}
16283	494	14	{72}
16284	494	15	{81}
16285	494	16	{86}
16286	494	17	{91}
16287	494	18	{95}
16288	494	19	{101}
16289	494	20	{105}
16290	494	21	{109}
16291	494	22	{116}
16292	494	23	{121}
16293	494	24	{126}
16294	494	25	{130}
16295	494	26	{133,134}
16296	494	27	{142}
16297	494	28	{146}
16298	494	29	{150,149,154}
16299	494	30	{157}
16300	494	31	{163,165,169}
16301	494	32	{171}
16302	494	33	{181,176,180}
16303	495	1	{5}
16304	495	2	{10}
16305	495	3	{15}
16306	495	4	{20}
16307	495	5	{25}
16308	495	6	{30}
16309	495	7	{35}
16310	495	8	{40}
16311	495	9	{42,48,46,47}
16312	495	10	{53,50}
16313	495	11	{61}
16314	495	12	{66}
16315	495	13	{70}
16316	495	14	{76}
16317	495	15	{80}
16318	495	16	{84}
16319	495	17	{91}
16320	495	18	{95}
16321	495	19	{100}
16322	495	20	{106}
16323	495	21	{111}
16324	495	22	{115}
16325	495	23	{121}
16326	495	24	{124}
16327	495	25	{131}
16328	495	26	{133,132,137}
16329	495	27	{142}
16330	495	28	{147}
16331	495	29	{153,149}
16332	495	30	{160}
16333	495	31	{167,165}
16334	495	32	{172}
16335	495	33	{179,177}
16336	496	1	{5}
16337	496	2	{10}
16338	496	3	{15}
16339	496	4	{17}
16340	496	5	{25}
16341	496	6	{30}
16342	496	7	{35}
16343	496	8	{40}
16344	496	9	{46,43}
16345	496	10	{53,50,49}
16346	496	11	{61}
16347	496	12	{66}
16348	496	13	{71}
16349	496	14	{76}
16350	496	15	{81}
16351	496	16	{86}
16352	496	17	{91}
16353	496	18	{95}
16354	496	19	{101}
16355	496	20	{105}
16356	496	21	{111}
16357	496	22	{115}
16358	496	23	{121}
16359	496	24	{125}
16360	496	25	{131}
16361	496	26	{133,132,136}
16362	496	27	{141}
16363	496	28	{147}
16364	496	29	{153,150,149}
16365	496	30	{160}
16366	496	31	{167,165,164}
16367	496	32	{172}
16368	496	33	{179,180,175,173}
16369	497	1	{5}
16370	497	2	{10}
16371	497	3	{11}
16372	497	4	{20}
16373	497	5	{25}
16374	497	6	{30}
16375	497	7	{35}
16376	497	8	{40}
16377	497	9	{48,44}
16378	497	10	{53,50,51,55}
16379	497	11	{61}
16380	497	12	{66}
16381	497	13	{67}
16382	497	14	{75}
16383	497	15	{81}
16384	497	16	{86}
16385	497	17	{91}
16386	497	18	{96}
16387	497	19	{101}
16388	497	20	{106}
16389	497	21	{111}
16390	497	22	{115}
16391	497	23	{121}
16392	497	24	{126}
16393	497	25	{131}
16394	497	26	{132,135}
16395	497	27	{139}
16396	497	28	{147}
16397	497	29	{150,149}
16398	497	30	{157}
16399	497	31	{163,168,165,169}
16400	497	32	{171}
16401	497	33	{179,174}
16402	498	1	{5}
16403	498	2	{10}
16404	498	3	{15}
16405	498	4	{19}
16406	498	5	{25}
16407	498	6	{27}
16408	498	7	{35}
16409	498	8	{40}
16410	498	9	{43,41,47,45}
16411	498	10	{54,51,55,52}
16412	498	11	{61}
16413	498	12	{66}
16414	498	13	{67}
16415	498	14	{76}
16416	498	15	{80}
16417	498	16	{86}
16418	498	17	{90}
16419	498	18	{96}
16420	498	19	{101}
16421	498	20	{106}
16422	498	21	{111}
16423	498	22	{116}
16424	498	23	{121}
16425	498	24	{126}
16426	498	25	{131}
16427	498	26	{133,132,137}
16428	498	27	{142}
16429	498	28	{147}
16430	498	29	{151,148}
16431	498	30	{159}
16432	498	31	{163,166}
16433	498	32	{171}
16434	498	33	{178,179,176,174}
16435	499	1	{4}
16436	499	2	{10}
16437	499	3	{15}
16438	499	4	{20}
16439	499	5	{25}
16440	499	6	{29}
16441	499	7	{35}
16442	499	8	{40}
16443	499	9	{42,43}
16444	499	10	{53,51,56}
16445	499	11	{60}
16446	499	12	{66}
16447	499	13	{71}
16448	499	14	{75}
16449	499	15	{78}
16450	499	16	{86}
16451	499	17	{90}
16452	499	18	{96}
16453	499	19	{101}
16454	499	20	{106}
16455	499	21	{111}
16456	499	22	{116}
16457	499	23	{120}
16458	499	24	{126}
16459	499	25	{130}
16460	499	26	{135,134,136,137}
16461	499	27	{142}
16462	499	28	{146}
16463	499	29	{153,149,155}
16464	499	30	{160}
16465	499	31	{167,166,161,165}
16466	499	32	{171}
16467	499	33	{178,181,173}
16468	500	1	{5}
16469	500	2	{9}
16470	500	3	{15}
16471	500	4	{18}
16472	500	5	{25}
16473	500	6	{29}
16474	500	7	{35}
16475	500	8	{40}
16476	500	9	{48,41}
16477	500	10	{54,55,52}
16478	500	11	{58}
16479	500	12	{66}
16480	500	13	{71}
16481	500	14	{76}
16482	500	15	{80}
16483	500	16	{86}
16484	500	17	{90}
16485	500	18	{96}
16486	500	19	{98}
16487	500	20	{106}
16488	500	21	{111}
16489	500	22	{115}
16490	500	23	{121}
16491	500	24	{126}
16492	500	25	{131}
16493	500	26	{132,135,136}
16494	500	27	{142}
16495	500	28	{147}
16496	500	29	{153,152,154}
16497	500	30	{159}
16498	500	31	{166,161}
16499	500	32	{170}
16500	500	33	{178,181,175,177}
16501	4	1	{2}
16502	4	2	{7}
16503	4	3	{12}
16504	4	4	{17}
16505	4	5	{22}
16506	4	6	{27}
16507	4	7	{32}
16508	4	8	{37}
16509	4	9	{42,43}
16510	4	10	{50,51,52}
16511	4	11	{58}
16512	4	12	{63}
16513	4	13	{68}
16514	4	14	{73}
16515	4	15	{78}
16516	4	16	{83}
16517	4	17	{88}
16518	4	18	{93}
16519	4	19	{98}
16520	4	20	{103}
16521	4	21	{108}
16522	4	22	{113}
16523	4	23	{118}
16524	4	24	{123}
16525	4	25	{128}
16526	4	26	{133,134}
16527	4	27	{139}
16528	4	28	{144}
16529	4	29	{149,150}
16530	4	30	{157}
16531	4	31	{162,163,164}
16532	4	32	{171}
16533	4	33	{174,176,175}
\.


--
-- Data for Name: responses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.responses (response_id, company_id, total_score, created_at, cluster_id, ab_group) FROM stdin;
265	3	2.3372000000000006	2026-01-13 07:23:33.270113+00	2	\N
194	4	2.0858000000000008	2026-01-13 07:23:33.270113+00	2	\N
239	6	1.9390000000000007	2026-01-13 07:23:33.270113+00	2	\N
99	9	2.065	2026-01-13 07:23:33.270113+00	1	\N
204	10	2.2924	2026-01-13 07:23:33.270113+00	2	\N
454	17	3.9342	2026-01-13 07:23:33.270113+00	4	\N
139	25	2.1670000000000007	2026-01-13 07:23:33.270113+00	2	\N
188	29	2.1702000000000004	2026-01-13 07:23:33.270113+00	2	\N
82	31	1.8432	2026-01-13 07:23:33.270113+00	1	\N
388	32	2.857	2026-01-13 07:23:33.270113+00	3	\N
116	33	2.1940000000000004	2026-01-13 07:23:33.270113+00	2	\N
54	34	1.7402	2026-01-13 07:23:33.270113+00	1	\N
318	36	2.86	2026-01-13 07:23:33.270113+00	3	\N
271	42	2.3100000000000005	2026-01-13 07:23:33.270113+00	2	\N
341	44	2.902200000000001	2026-01-13 07:23:33.270113+00	3	\N
110	45	2.131200000000001	2026-01-13 07:23:33.270113+00	2	\N
313	46	2.881	2026-01-13 07:23:33.270113+00	3	\N
350	48	2.8572	2026-01-13 07:23:33.270113+00	3	\N
392	51	2.9600000000000004	2026-01-13 07:23:33.270113+00	3	\N
215	57	2.049	2026-01-13 07:23:33.270113+00	2	\N
67	65	1.5128000000000004	2026-01-13 07:23:33.270113+00	1	\N
203	70	2.1402000000000005	2026-01-13 07:23:33.270113+00	2	\N
156	78	1.9250000000000007	2026-01-13 07:23:33.270113+00	2	\N
362	81	3.1512	2026-01-13 07:23:33.270113+00	3	\N
208	82	2.1100000000000008	2026-01-13 07:23:33.270113+00	2	\N
72	83	1.828	2026-01-13 07:23:33.270113+00	1	\N
29	85	1.5	2026-01-13 07:23:33.270113+00	1	\N
7	88	1.2340000000000002	2026-01-13 07:23:33.270113+00	1	\N
298	89	2.3378	2026-01-13 07:23:33.270113+00	2	\N
481	96	3.4292	2026-01-13 07:23:33.270113+00	4	\N
472	97	3.5658	2026-01-13 07:23:33.270113+00	4	\N
310	99	2.906	2026-01-13 07:23:33.270113+00	3	\N
234	100	2.275000000000001	2026-01-13 07:23:33.270113+00	2	\N
262	102	2.1822000000000004	2026-01-13 07:23:33.270113+00	2	\N
440	103	3.4972000000000008	2026-01-13 07:23:33.270113+00	4	\N
477	108	3.8972	2026-01-13 07:23:33.270113+00	4	\N
69	112	1.9318	2026-01-13 07:23:33.270113+00	1	\N
100	114	1.4330000000000005	2026-01-13 07:23:33.270113+00	1	\N
155	123	2.2326000000000006	2026-01-13 07:23:33.270113+00	2	\N
218	126	2.0700000000000003	2026-01-13 07:23:33.270113+00	2	\N
206	127	2.1	2026-01-13 07:23:33.270113+00	2	\N
64	129	1.449	2026-01-13 07:23:33.270113+00	1	\N
464	132	4.065800000000001	2026-01-13 07:23:33.270113+00	4	\N
323	133	3.2076	2026-01-13 07:23:33.270113+00	3	\N
183	134	2.279200000000001	2026-01-13 07:23:33.270113+00	2	\N
34	136	1.3580000000000003	2026-01-13 07:23:33.270113+00	1	\N
24	137	1.5178000000000005	2026-01-13 07:23:33.270113+00	1	\N
282	138	2.326200000000001	2026-01-13 07:23:33.270113+00	2	\N
375	142	2.881	2026-01-13 07:23:33.270113+00	3	\N
93	144	1.3108000000000002	2026-01-13 07:23:33.270113+00	1	\N
274	147	2.1022000000000007	2026-01-13 07:23:33.270113+00	2	\N
320	148	2.9970000000000003	2026-01-13 07:23:33.270113+00	3	\N
222	149	2.269	2026-01-13 07:23:33.270113+00	2	\N
285	150	1.8610000000000004	2026-01-13 07:23:33.270113+00	2	\N
102	152	1.9700000000000004	2026-01-13 07:23:33.270113+00	2	\N
434	154	3.691200000000001	2026-01-13 07:23:33.270113+00	4	\N
154	159	2.2210000000000005	2026-01-13 07:23:33.270113+00	2	\N
87	180	1.7636	2026-01-13 07:23:33.270113+00	1	\N
224	182	2.0436	2026-01-13 07:23:33.270113+00	2	\N
352	183	2.9150000000000005	2026-01-13 07:23:33.270113+00	3	\N
336	184	3.0556000000000005	2026-01-13 07:23:33.270113+00	3	\N
241	185	2.2738	2026-01-13 07:23:33.270113+00	2	\N
62	186	1.699	2026-01-13 07:23:33.270113+00	1	\N
387	190	2.8202	2026-01-13 07:23:33.270113+00	3	\N
42	195	1.5737999999999996	2026-01-13 07:23:33.270113+00	1	\N
8	196	1.5102	2026-01-13 07:23:33.270113+00	1	\N
306	201	2.72	2026-01-13 07:23:33.270113+00	3	\N
278	206	2.2632000000000003	2026-01-13 07:23:33.270113+00	2	\N
449	209	3.937000000000001	2026-01-13 07:23:33.270113+00	4	\N
223	210	1.9896000000000005	2026-01-13 07:23:33.270113+00	2	\N
30	212	1.3610000000000002	2026-01-13 07:23:33.270113+00	1	\N
324	215	2.8752	2026-01-13 07:23:33.270113+00	3	\N
6	217	1.6449999999999998	2026-01-13 07:23:33.270113+00	1	\N
135	222	2.1216000000000004	2026-01-13 07:23:33.270113+00	2	\N
473	223	3.6762	2026-01-13 07:23:33.270113+00	4	\N
151	224	2.0798	2026-01-13 07:23:33.270113+00	2	\N
368	228	2.753	2026-01-13 07:23:33.270113+00	3	\N
73	229	1.72	2026-01-13 07:23:33.270113+00	1	\N
484	233	3.8320000000000007	2026-01-13 07:23:33.270113+00	4	\N
217	234	2.4870000000000005	2026-01-13 07:23:33.270113+00	2	\N
279	235	2.164	2026-01-13 07:23:33.270113+00	2	\N
118	240	2.1766000000000005	2026-01-13 07:23:33.270113+00	2	\N
5	241	1.4952	2026-01-13 07:23:33.270113+00	1	\N
32	243	1.819	2026-01-13 07:23:33.270113+00	1	\N
213	245	2.2568000000000006	2026-01-13 07:23:33.270113+00	2	\N
81	246	1.6172000000000004	2026-01-13 07:23:33.270113+00	1	\N
168	253	1.9336000000000004	2026-01-13 07:23:33.270113+00	2	\N
157	258	2.3790000000000004	2026-01-13 07:23:33.270113+00	2	\N
235	259	2.446	2026-01-13 07:23:33.270113+00	2	\N
228	260	2.1376000000000004	2026-01-13 07:23:33.270113+00	2	\N
115	262	2.0050000000000003	2026-01-13 07:23:33.270113+00	2	\N
483	263	3.7324000000000006	2026-01-13 07:23:33.270113+00	4	\N
347	264	2.9452	2026-01-13 07:23:33.270113+00	3	\N
356	266	2.8440000000000003	2026-01-13 07:23:33.270113+00	3	\N
84	267	1.4067999999999996	2026-01-13 07:23:33.270113+00	1	\N
345	269	2.8160000000000003	2026-01-13 07:23:33.270113+00	3	\N
159	272	2.170200000000001	2026-01-13 07:23:33.270113+00	2	\N
380	273	2.929	2026-01-13 07:23:33.270113+00	3	\N
374	276	2.9374	2026-01-13 07:23:33.270113+00	3	\N
80	277	1.466	2026-01-13 07:23:33.270113+00	1	\N
314	278	2.915	2026-01-13 07:23:33.270113+00	3	\N
184	279	2.1332000000000004	2026-01-13 07:23:33.270113+00	2	\N
406	282	2.9440000000000004	2026-01-13 07:23:33.270113+00	3	\N
491	286	4.0968	2026-01-13 07:23:33.270113+00	5	\N
254	287	2.3692	2026-01-13 07:23:33.270113+00	2	\N
113	291	2.0290000000000004	2026-01-13 07:23:33.270113+00	2	\N
105	294	2.1376000000000004	2026-01-13 07:23:33.270113+00	2	\N
267	297	2.1790000000000007	2026-01-13 07:23:33.270113+00	2	\N
286	298	2.1972000000000005	2026-01-13 07:23:33.270113+00	2	\N
123	303	2.0952000000000006	2026-01-13 07:23:33.270113+00	2	\N
21	304	1.5260000000000005	2026-01-13 07:23:33.270113+00	1	\N
381	307	2.8392	2026-01-13 07:23:33.270113+00	3	\N
404	308	2.846199999999999	2026-01-13 07:23:33.270113+00	3	\N
108	310	2.31	2026-01-13 07:23:33.270113+00	2	\N
17	311	1.6600000000000004	2026-01-13 07:23:33.270113+00	1	\N
45	313	1.8022	2026-01-13 07:23:33.270113+00	1	\N
409	314	3.0128	2026-01-13 07:23:33.270113+00	3	\N
92	316	2.1230000000000007	2026-01-13 07:23:33.270113+00	1	\N
287	318	2.2590000000000003	2026-01-13 07:23:33.270113+00	2	\N
3	319	1.3882000000000003	2026-01-13 07:23:33.270113+00	1	\N
1	320	1.5878	2026-01-13 07:23:33.270113+00	1	\N
400	326	3.1712	2026-01-13 07:23:33.270113+00	3	\N
192	328	2.113000000000001	2026-01-13 07:23:33.270113+00	2	\N
170	329	2.2612000000000005	2026-01-13 07:23:33.270113+00	2	\N
186	331	2.043200000000001	2026-01-13 07:23:33.270113+00	2	\N
395	334	2.7402	2026-01-13 07:23:33.270113+00	3	\N
136	335	2.0312	2026-01-13 07:23:33.270113+00	2	\N
272	336	2.28	2026-01-13 07:23:33.270113+00	2	\N
79	341	1.422	2026-01-13 07:23:33.270113+00	1	\N
129	342	2.1716000000000006	2026-01-13 07:23:33.270113+00	2	\N
418	343	3.0536	2026-01-13 07:23:33.270113+00	3	\N
384	345	2.7141999999999995	2026-01-13 07:23:33.270113+00	3	\N
227	347	2.249000000000001	2026-01-13 07:23:33.270113+00	2	\N
488	348	4.520200000000001	2026-01-13 07:23:33.270113+00	5	\N
143	356	2.0166	2026-01-13 07:23:33.270113+00	2	\N
443	358	3.779000000000001	2026-01-13 07:23:33.270113+00	4	\N
103	363	2.198200000000001	2026-01-13 07:23:33.270113+00	2	\N
459	366	3.767600000000001	2026-01-13 07:23:33.270113+00	4	\N
389	370	2.7612	2026-01-13 07:23:33.270113+00	3	\N
462	372	3.747400000000001	2026-01-13 07:23:33.270113+00	4	\N
238	380	1.9522000000000008	2026-01-13 07:23:33.270113+00	2	\N
83	386	1.6406	2026-01-13 07:23:33.270113+00	1	\N
450	391	3.557200000000001	2026-01-13 07:23:33.270113+00	4	\N
432	403	3.7360000000000015	2026-01-13 07:23:33.270113+00	4	\N
437	405	3.9172	2026-01-13 07:23:33.270113+00	4	\N
15	407	1.4382000000000004	2026-01-13 07:23:33.270113+00	1	\N
325	409	2.9578	2026-01-13 07:23:33.270113+00	3	\N
31	415	1.5822	2026-01-13 07:23:33.270113+00	1	\N
22	416	1.685	2026-01-13 07:23:33.270113+00	1	\N
38	420	1.5076	2026-01-13 07:23:33.270113+00	1	\N
91	429	1.8940000000000008	2026-01-13 07:23:33.270113+00	1	\N
112	430	2.1170000000000004	2026-01-13 07:23:33.270113+00	2	\N
28	431	1.5952000000000002	2026-01-13 07:23:33.270113+00	1	\N
152	434	2.029200000000001	2026-01-13 07:23:33.270113+00	2	\N
413	436	3.048	2026-01-13 07:23:33.270113+00	3	\N
397	439	2.9366000000000003	2026-01-13 07:23:33.270113+00	3	\N
26	441	1.4812	2026-01-13 07:23:33.270113+00	1	\N
328	444	2.928	2026-01-13 07:23:33.270113+00	3	\N
35	445	1.3256000000000003	2026-01-13 07:23:33.270113+00	1	\N
383	450	2.955	2026-01-13 07:23:33.270113+00	3	\N
221	451	2.2008	2026-01-13 07:23:33.270113+00	2	\N
333	453	3.0350000000000006	2026-01-13 07:23:33.270113+00	3	\N
41	454	1.5782000000000005	2026-01-13 07:23:33.270113+00	1	\N
251	456	2.0092000000000003	2026-01-13 07:23:33.270113+00	2	\N
366	461	2.9092	2026-01-13 07:23:33.270113+00	3	\N
439	462	3.7680000000000007	2026-01-13 07:23:33.270113+00	4	\N
33	463	1.4102	2026-01-13 07:23:33.270113+00	1	\N
312	465	2.7442	2026-01-13 07:23:33.270113+00	3	\N
27	471	1.7072	2026-01-13 07:23:33.270113+00	1	\N
321	473	2.9724	2026-01-13 07:23:33.270113+00	3	\N
290	477	2.416	2026-01-13 07:23:33.270113+00	2	\N
433	488	3.777400000000001	2026-01-13 07:23:33.270113+00	4	\N
338	492	3.067	2026-01-13 07:23:33.270113+00	3	\N
144	494	2.418	2026-01-13 07:23:33.270113+00	2	\N
127	496	2.317600000000001	2026-01-13 07:23:33.270113+00	2	\N
243	497	2.0880000000000005	2026-01-13 07:23:33.270113+00	2	\N
447	498	3.5152	2026-01-13 07:23:33.270113+00	4	\N
66	501	1.592	2026-01-13 07:23:33.270113+00	1	\N
50	504	1.7948000000000002	2026-01-13 07:23:33.270113+00	1	\N
315	511	3.0828	2026-01-13 07:23:33.270113+00	3	\N
326	515	3.0892	2026-01-13 07:23:33.270113+00	3	\N
124	516	2.261000000000001	2026-01-13 07:23:33.270113+00	2	\N
424	517	2.7179999999999995	2026-01-13 07:23:33.270113+00	3	\N
316	520	2.935600000000001	2026-01-13 07:23:33.270113+00	3	\N
382	524	2.879	2026-01-13 07:23:33.270113+00	3	\N
11	525	1.4240000000000006	2026-01-13 07:23:33.270113+00	1	\N
390	527	2.9442000000000004	2026-01-13 07:23:33.270113+00	3	\N
200	528	2.1850000000000005	2026-01-13 07:23:33.270113+00	2	\N
141	531	1.9712000000000005	2026-01-13 07:23:33.270113+00	2	\N
485	532	3.517	2026-01-13 07:23:33.270113+00	4	\N
270	533	2.2880000000000003	2026-01-13 07:23:33.270113+00	2	\N
232	539	2.1142000000000007	2026-01-13 07:23:33.270113+00	2	\N
291	542	2.35	2026-01-13 07:23:33.270113+00	2	\N
299	549	2.0464	2026-01-13 07:23:33.270113+00	2	\N
408	553	3.2825999999999995	2026-01-13 07:23:33.270113+00	3	\N
482	556	3.9942	2026-01-13 07:23:33.270113+00	4	\N
281	562	2.032	2026-01-13 07:23:33.270113+00	2	\N
147	563	1.9680000000000004	2026-01-13 07:23:33.270113+00	2	\N
162	564	2.060600000000001	2026-01-13 07:23:33.270113+00	2	\N
423	569	2.9920000000000004	2026-01-13 07:23:33.270113+00	3	\N
86	574	1.622	2026-01-13 07:23:33.270113+00	1	\N
63	576	1.656	2026-01-13 07:23:33.270113+00	1	\N
210	577	2.0978000000000003	2026-01-13 07:23:33.270113+00	2	\N
117	580	1.9970000000000008	2026-01-13 07:23:33.270113+00	2	\N
205	592	2.3546000000000005	2026-01-13 07:23:33.270113+00	2	\N
153	596	2.3828000000000005	2026-01-13 07:23:33.270113+00	2	\N
416	600	2.908000000000001	2026-01-13 07:23:33.270113+00	3	\N
463	602	3.7034	2026-01-13 07:23:33.270113+00	4	\N
376	606	2.575	2026-01-13 07:23:33.270113+00	3	\N
58	615	1.5012000000000003	2026-01-13 07:23:33.270113+00	1	\N
148	616	2.1220000000000008	2026-01-13 07:23:33.270113+00	2	\N
398	619	2.627	2026-01-13 07:23:33.270113+00	3	\N
349	622	2.865	2026-01-13 07:23:33.270113+00	3	\N
128	625	2.103800000000001	2026-01-13 07:23:33.270113+00	2	\N
111	626	2.1706000000000003	2026-01-13 07:23:33.270113+00	2	\N
346	628	2.963	2026-01-13 07:23:33.270113+00	3	\N
2	629	1.4760000000000002	2026-01-13 07:23:33.270113+00	1	\N
378	630	2.7980000000000005	2026-01-13 07:23:33.270113+00	3	\N
146	631	2.1910000000000007	2026-01-13 07:23:33.270113+00	2	\N
177	635	2.3012000000000006	2026-01-13 07:23:33.270113+00	2	\N
193	643	2.0950000000000006	2026-01-13 07:23:33.270113+00	2	\N
471	645	3.881600000000001	2026-01-13 07:23:33.270113+00	4	\N
18	648	1.5132	2026-01-13 07:23:33.270113+00	1	\N
16	653	1.3332000000000004	2026-01-13 07:23:33.270113+00	1	\N
436	662	3.732200000000001	2026-01-13 07:23:33.270113+00	4	\N
467	666	3.8802	2026-01-13 07:23:33.270113+00	4	\N
457	669	3.781000000000001	2026-01-13 07:23:33.270113+00	4	\N
36	671	1.521	2026-01-13 07:23:33.270113+00	1	\N
461	672	3.9012	2026-01-13 07:23:33.270113+00	4	\N
307	673	2.9432	2026-01-13 07:23:33.270113+00	3	\N
97	674	1.6930000000000005	2026-01-13 07:23:33.270113+00	1	\N
493	676	4.2208	2026-01-13 07:23:33.270113+00	5	\N
98	679	1.4762000000000004	2026-01-13 07:23:33.270113+00	1	\N
43	681	1.5008000000000004	2026-01-13 07:23:33.270113+00	1	\N
257	682	2.2762000000000007	2026-01-13 07:23:33.270113+00	2	\N
39	684	1.7551999999999996	2026-01-13 07:23:33.270113+00	1	\N
47	690	1.3634000000000004	2026-01-13 07:23:33.270113+00	1	\N
407	695	2.7911999999999995	2026-01-13 07:23:33.270113+00	3	\N
429	697	3.514	2026-01-13 07:23:33.270113+00	4	\N
478	701	3.6882000000000006	2026-01-13 07:23:33.270113+00	4	\N
261	706	2.2672000000000003	2026-01-13 07:23:33.270113+00	2	\N
65	709	1.7959999999999998	2026-01-13 07:23:33.270113+00	1	\N
343	718	3.064	2026-01-13 07:23:33.270113+00	3	\N
377	719	2.888	2026-01-13 07:23:33.270113+00	3	\N
385	724	2.9976000000000003	2026-01-13 07:23:33.270113+00	3	\N
344	727	2.746200000000001	2026-01-13 07:23:33.270113+00	3	\N
56	728	1.558	2026-01-13 07:23:33.270113+00	1	\N
353	732	2.7336	2026-01-13 07:23:33.270113+00	3	\N
9	733	1.7480000000000002	2026-01-13 07:23:33.270113+00	1	\N
132	734	2.1950000000000007	2026-01-13 07:23:33.270113+00	2	\N
415	735	3.1500000000000004	2026-01-13 07:23:33.270113+00	3	\N
456	739	3.827000000000001	2026-01-13 07:23:33.270113+00	4	\N
19	745	1.8192	2026-01-13 07:23:33.270113+00	1	\N
181	747	2.0262000000000007	2026-01-13 07:23:33.270113+00	2	\N
474	748	3.9778000000000007	2026-01-13 07:23:33.270113+00	4	\N
486	750	4.3014	2026-01-13 07:23:33.270113+00	5	\N
130	753	2.0642000000000005	2026-01-13 07:23:33.270113+00	2	\N
365	757	2.8656	2026-01-13 07:23:33.270113+00	3	\N
225	760	2.0470000000000006	2026-01-13 07:23:33.270113+00	2	\N
245	768	2.162000000000001	2026-01-13 07:23:33.270113+00	2	\N
236	770	2.2656000000000005	2026-01-13 07:23:33.270113+00	2	\N
490	773	4.4998000000000005	2026-01-13 07:23:33.270113+00	5	\N
309	775	2.9810000000000008	2026-01-13 07:23:33.270113+00	3	\N
25	778	1.5052000000000003	2026-01-13 07:23:33.270113+00	1	\N
12	781	1.4242000000000004	2026-01-13 07:23:33.270113+00	1	\N
229	782	2.1010000000000004	2026-01-13 07:23:33.270113+00	2	\N
266	783	2.0586	2026-01-13 07:23:33.270113+00	2	\N
121	788	2.3288000000000006	2026-01-13 07:23:33.270113+00	2	\N
329	789	2.931999999999999	2026-01-13 07:23:33.270113+00	3	\N
48	797	1.5589999999999995	2026-01-13 07:23:33.270113+00	1	\N
85	799	1.6734000000000002	2026-01-13 07:23:33.270113+00	1	\N
169	803	1.9934	2026-01-13 07:23:33.270113+00	2	\N
442	809	3.585400000000001	2026-01-13 07:23:33.270113+00	4	\N
319	826	3.028	2026-01-13 07:23:33.270113+00	3	\N
219	828	1.968	2026-01-13 07:23:33.270113+00	2	\N
391	830	2.887	2026-01-13 07:23:33.270113+00	3	\N
211	835	2.2952000000000004	2026-01-13 07:23:33.270113+00	2	\N
233	836	2.258	2026-01-13 07:23:33.270113+00	2	\N
176	837	2.049000000000001	2026-01-13 07:23:33.270113+00	2	\N
489	841	4.2996	2026-01-13 07:23:33.270113+00	5	\N
37	844	1.547	2026-01-13 07:23:33.270113+00	1	\N
351	845	3.0992	2026-01-13 07:23:33.270113+00	3	\N
70	846	1.541	2026-01-13 07:23:33.270113+00	1	\N
226	847	2.455	2026-01-13 07:23:33.270113+00	2	\N
53	849	1.5430000000000006	2026-01-13 07:23:33.270113+00	1	\N
20	852	1.865	2026-01-13 07:23:33.270113+00	1	\N
452	857	3.7252000000000014	2026-01-13 07:23:33.270113+00	4	\N
175	858	2.0982	2026-01-13 07:23:33.270113+00	2	\N
414	859	2.7970000000000006	2026-01-13 07:23:33.270113+00	3	\N
133	860	2.392	2026-01-13 07:23:33.270113+00	2	\N
364	862	2.797	2026-01-13 07:23:33.270113+00	3	\N
220	865	1.9760000000000009	2026-01-13 07:23:33.270113+00	2	\N
275	872	2.2550000000000003	2026-01-13 07:23:33.270113+00	2	\N
294	873	2.061	2026-01-13 07:23:33.270113+00	2	\N
244	876	1.9660000000000004	2026-01-13 07:23:33.270113+00	2	\N
258	877	2.156200000000001	2026-01-13 07:23:33.270113+00	2	\N
339	880	3.221	2026-01-13 07:23:33.270113+00	3	\N
273	882	2.0980000000000008	2026-01-13 07:23:33.270113+00	2	\N
94	884	1.7340000000000004	2026-01-13 07:23:33.270113+00	1	\N
435	886	3.829800000000001	2026-01-13 07:23:33.270113+00	4	\N
401	888	3.0312	2026-01-13 07:23:33.270113+00	3	\N
158	889	2.0692000000000004	2026-01-13 07:23:33.270113+00	2	\N
425	891	3.0362	2026-01-13 07:23:33.270113+00	3	\N
119	894	2.363	2026-01-13 07:23:33.270113+00	2	\N
253	898	2.3822000000000005	2026-01-13 07:23:33.270113+00	2	\N
142	903	2.1102000000000003	2026-01-13 07:23:33.270113+00	2	\N
363	905	3.041200000000001	2026-01-13 07:23:33.270113+00	3	\N
76	908	1.643	2026-01-13 07:23:33.270113+00	1	\N
302	909	2.9072	2026-01-13 07:23:33.270113+00	3	\N
280	910	2.2250000000000005	2026-01-13 07:23:33.270113+00	2	\N
311	911	2.905	2026-01-13 07:23:33.270113+00	3	\N
458	927	3.9580000000000015	2026-01-13 07:23:33.270113+00	4	\N
49	928	1.4258000000000004	2026-01-13 07:23:33.270113+00	1	\N
190	931	2.160000000000001	2026-01-13 07:23:33.270113+00	2	\N
55	932	1.6706	2026-01-13 07:23:33.270113+00	1	\N
252	933	2.4092	2026-01-13 07:23:33.270113+00	2	\N
426	937	3.629000000000001	2026-01-13 07:23:33.270113+00	4	\N
231	943	1.9416000000000004	2026-01-13 07:23:33.270113+00	2	\N
412	944	3.0022	2026-01-13 07:23:33.270113+00	3	\N
494	950	4.0308	2026-01-13 07:23:33.270113+00	5	\N
160	953	2.3632	2026-01-13 07:23:33.270113+00	2	\N
23	963	1.2492000000000003	2026-01-13 07:23:33.270113+00	1	\N
487	964	4.361200000000001	2026-01-13 07:23:33.270113+00	5	\N
134	967	2.2214	2026-01-13 07:23:33.270113+00	2	\N
411	969	2.9410000000000007	2026-01-13 07:23:33.270113+00	3	\N
297	972	2.6876000000000007	2026-01-13 07:23:33.270113+00	2	\N
214	975	1.8574000000000004	2026-01-13 07:23:33.270113+00	2	\N
468	976	3.9902	2026-01-13 07:23:33.270113+00	4	\N
451	979	3.9082	2026-01-13 07:23:33.270113+00	4	\N
260	982	2.1402000000000005	2026-01-13 07:23:33.270113+00	2	\N
187	989	2.1072	2026-01-13 07:23:33.270113+00	2	\N
256	997	2.019000000000001	2026-01-13 07:23:33.270113+00	2	\N
354	999	3.0342	2026-01-13 07:23:33.270113+00	3	\N
264	1000	1.9290000000000005	2026-01-13 07:23:33.270113+00	2	\N
431	1003	3.9622000000000006	2026-01-13 07:23:33.270113+00	4	\N
230	1004	2.0960000000000005	2026-01-13 07:23:33.270113+00	2	\N
371	1005	2.8162000000000003	2026-01-13 07:23:33.270113+00	3	\N
201	1012	2.1712	2026-01-13 07:23:33.270113+00	2	\N
172	1015	1.9970000000000003	2026-01-13 07:23:33.270113+00	2	\N
263	1018	2.1766000000000005	2026-01-13 07:23:33.270113+00	2	\N
163	1021	2.0702000000000003	2026-01-13 07:23:33.270113+00	2	\N
289	1023	2.016	2026-01-13 07:23:33.270113+00	2	\N
197	1024	2.079	2026-01-13 07:23:33.270113+00	2	\N
46	1025	1.8218	2026-01-13 07:23:33.270113+00	1	\N
419	1032	3.0216000000000007	2026-01-13 07:23:33.270113+00	3	\N
191	1037	2.0532000000000004	2026-01-13 07:23:33.270113+00	2	\N
357	1044	3.0928	2026-01-13 07:23:33.270113+00	3	\N
269	1045	2.217000000000001	2026-01-13 07:23:33.270113+00	2	\N
131	1050	1.8754000000000008	2026-01-13 07:23:33.270113+00	2	\N
470	1052	3.9692	2026-01-13 07:23:33.270113+00	4	\N
120	1056	2.5000000000000004	2026-01-13 07:23:33.270113+00	2	\N
4	4	\N	2026-01-21 09:37:48.052966	\N	\N
283	1057	2.455	2026-01-13 07:23:33.270113+00	2	\N
96	1058	1.5682000000000005	2026-01-13 07:23:33.270113+00	1	\N
396	1064	2.9730000000000003	2026-01-13 07:23:33.270113+00	3	\N
288	1072	1.8022000000000005	2026-01-13 07:23:33.270113+00	2	\N
421	1075	2.9356	2026-01-13 07:23:33.270113+00	3	\N
212	1076	2.221	2026-01-13 07:23:33.270113+00	2	\N
340	1083	2.976999999999999	2026-01-13 07:23:33.270113+00	3	\N
74	1086	1.6166	2026-01-13 07:23:33.270113+00	1	\N
174	1088	2.0490000000000004	2026-01-13 07:23:33.270113+00	2	\N
75	1090	1.7907999999999995	2026-01-13 07:23:33.270113+00	1	\N
455	1091	3.172799999999999	2026-01-13 07:23:33.270113+00	4	\N
237	1092	2.4814000000000003	2026-01-13 07:23:33.270113+00	2	\N
448	1095	3.858800000000001	2026-01-13 07:23:33.270113+00	4	\N
420	1100	2.9502	2026-01-13 07:23:33.270113+00	3	\N
51	1101	1.4806	2026-01-13 07:23:33.270113+00	1	\N
479	1102	3.6672	2026-01-13 07:23:33.270113+00	4	\N
126	1103	2.1896000000000004	2026-01-13 07:23:33.270113+00	2	\N
61	1104	1.3426000000000002	2026-01-13 07:23:33.270113+00	1	\N
167	1110	2.2210000000000005	2026-01-13 07:23:33.270113+00	2	\N
277	1116	2.2762	2026-01-13 07:23:33.270113+00	2	\N
247	1118	2.1302000000000003	2026-01-13 07:23:33.270113+00	2	\N
195	1119	2.0406000000000004	2026-01-13 07:23:33.270113+00	2	\N
369	1121	2.8764	2026-01-13 07:23:33.270113+00	3	\N
68	1123	1.5992000000000002	2026-01-13 07:23:33.270113+00	1	\N
296	1125	2.172200000000001	2026-01-13 07:23:33.270113+00	2	\N
77	1126	1.4230000000000005	2026-01-13 07:23:33.270113+00	1	\N
60	1127	1.6240000000000003	2026-01-13 07:23:33.270113+00	1	\N
342	1128	2.9232	2026-01-13 07:23:33.270113+00	3	\N
402	1130	2.792	2026-01-13 07:23:33.270113+00	3	\N
476	1132	3.8560000000000008	2026-01-13 07:23:33.270113+00	4	\N
242	1138	2.1066000000000003	2026-01-13 07:23:33.270113+00	2	\N
500	522	4.2578000000000005	2026-01-13 07:23:33.270113+00	5	\N
498	558	4.369	2026-01-13 07:23:33.270113+00	5	\N
497	605	4.236199999999999	2026-01-13 07:23:33.270113+00	5	\N
499	715	4.3722	2026-01-13 07:23:33.270113+00	5	\N
122	1139	2.1626000000000003	2026-01-13 07:23:33.270113+00	2	\N
480	1144	3.6818	2026-01-13 07:23:33.270113+00	4	\N
180	1146	2.366	2026-01-13 07:23:33.270113+00	2	\N
348	1152	2.947	2026-01-13 07:23:33.270113+00	3	\N
71	1157	1.9510000000000003	2026-01-13 07:23:33.270113+00	1	\N
465	1158	4.030600000000001	2026-01-13 07:23:33.270113+00	4	\N
495	1170	4.345000000000001	2026-01-13 07:23:33.270113+00	5	\N
492	1171	4.1662	2026-01-13 07:23:33.270113+00	5	\N
335	1172	3.1510000000000007	2026-01-13 07:23:33.270113+00	3	\N
199	1175	2.383200000000001	2026-01-13 07:23:33.270113+00	2	\N
114	1177	2.3482000000000003	2026-01-13 07:23:33.270113+00	2	\N
304	1189	2.814999999999999	2026-01-13 07:23:33.270113+00	3	\N
334	1191	2.887000000000001	2026-01-13 07:23:33.270113+00	3	\N
303	1192	3.084	2026-01-13 07:23:33.270113+00	3	\N
300	1197	2.3922000000000008	2026-01-13 07:23:33.270113+00	2	\N
355	1199	3.1020000000000008	2026-01-13 07:23:33.270113+00	3	\N
370	1201	2.9802000000000004	2026-01-13 07:23:33.270113+00	3	\N
185	1202	1.9142000000000008	2026-01-13 07:23:33.270113+00	2	\N
246	1203	2.1810000000000005	2026-01-13 07:23:33.270113+00	2	\N
475	1204	3.5242	2026-01-13 07:23:33.270113+00	4	\N
165	1211	2.059	2026-01-13 07:23:33.270113+00	2	\N
438	1216	3.846800000000001	2026-01-13 07:23:33.270113+00	4	\N
173	1218	2.2800000000000007	2026-01-13 07:23:33.270113+00	2	\N
106	1221	2.0490000000000004	2026-01-13 07:23:33.270113+00	2	\N
403	1225	2.678	2026-01-13 07:23:33.270113+00	3	\N
337	1230	2.776	2026-01-13 07:23:33.270113+00	3	\N
178	1234	2.369	2026-01-13 07:23:33.270113+00	2	\N
137	1237	2.124000000000001	2026-01-13 07:23:33.270113+00	2	\N
259	1241	1.9922000000000009	2026-01-13 07:23:33.270113+00	2	\N
399	1248	2.8992000000000004	2026-01-13 07:23:33.270113+00	3	\N
171	1254	2.0320000000000005	2026-01-13 07:23:33.270113+00	2	\N
164	1255	1.9500000000000008	2026-01-13 07:23:33.270113+00	2	\N
255	1257	2.1290000000000004	2026-01-13 07:23:33.270113+00	2	\N
453	1259	3.952800000000001	2026-01-13 07:23:33.270113+00	4	\N
57	1261	1.3572000000000004	2026-01-13 07:23:33.270113+00	1	\N
394	1263	2.88	2026-01-13 07:23:33.270113+00	3	\N
405	1264	2.8790000000000004	2026-01-13 07:23:33.270113+00	3	\N
361	1265	2.890999999999999	2026-01-13 07:23:33.270113+00	3	\N
44	1266	1.7542000000000004	2026-01-13 07:23:33.270113+00	1	\N
13	1270	1.5812000000000004	2026-01-13 07:23:33.270113+00	1	\N
209	1272	2.099000000000001	2026-01-13 07:23:33.270113+00	2	\N
284	1273	2.2022000000000004	2026-01-13 07:23:33.270113+00	2	\N
386	1279	3.0382	2026-01-13 07:23:33.270113+00	3	\N
59	1283	1.5571999999999997	2026-01-13 07:23:33.270113+00	1	\N
496	1286	4.472	2026-01-13 07:23:33.270113+00	5	\N
308	1288	3.16	2026-01-13 07:23:33.270113+00	3	\N
90	1289	1.4552000000000005	2026-01-13 07:23:33.270113+00	1	\N
430	1290	3.685600000000001	2026-01-13 07:23:33.270113+00	4	\N
196	1292	1.919000000000001	2026-01-13 07:23:33.270113+00	2	\N
95	1293	1.6810000000000005	2026-01-13 07:23:33.270113+00	1	\N
189	1294	2.249200000000001	2026-01-13 07:23:33.270113+00	2	\N
360	1297	2.779	2026-01-13 07:23:33.270113+00	3	\N
140	1298	2.3554	2026-01-13 07:23:33.270113+00	2	\N
202	1299	2.2330000000000005	2026-01-13 07:23:33.270113+00	2	\N
216	1301	1.9770000000000003	2026-01-13 07:23:33.270113+00	2	\N
295	1304	2.0602000000000005	2026-01-13 07:23:33.270113+00	2	\N
466	1315	3.764400000000001	2026-01-13 07:23:33.270113+00	4	\N
410	1317	2.9712	2026-01-13 07:23:33.270113+00	3	\N
166	1323	2.1806	2026-01-13 07:23:33.270113+00	2	\N
107	1324	2.2348000000000003	2026-01-13 07:23:33.270113+00	2	\N
207	1326	2.0782000000000003	2026-01-13 07:23:33.270113+00	2	\N
198	1328	2.3052	2026-01-13 07:23:33.270113+00	2	\N
10	1337	1.7106	2026-01-13 07:23:33.270113+00	1	\N
104	1338	2.1916	2026-01-13 07:23:33.270113+00	2	\N
444	1339	3.8438	2026-01-13 07:23:33.270113+00	4	\N
78	1341	1.7678	2026-01-13 07:23:33.270113+00	1	\N
250	1342	2.2438	2026-01-13 07:23:33.270113+00	2	\N
305	1345	3.08	2026-01-13 07:23:33.270113+00	3	\N
427	1349	3.9286000000000008	2026-01-13 07:23:33.270113+00	4	\N
109	1352	2.263000000000001	2026-01-13 07:23:33.270113+00	2	\N
322	1354	2.8982	2026-01-13 07:23:33.270113+00	3	\N
52	1357	1.6824000000000003	2026-01-13 07:23:33.270113+00	1	\N
327	1358	3.2044	2026-01-13 07:23:33.270113+00	3	\N
428	1363	4.060200000000001	2026-01-13 07:23:33.270113+00	4	\N
317	1367	3.1442	2026-01-13 07:23:33.270113+00	3	\N
161	1368	2.3742	2026-01-13 07:23:33.270113+00	2	\N
88	1369	1.6660000000000004	2026-01-13 07:23:33.270113+00	1	\N
89	1373	1.4000000000000004	2026-01-13 07:23:33.270113+00	1	\N
446	1377	3.6802000000000015	2026-01-13 07:23:33.270113+00	4	\N
145	1378	2.2220000000000004	2026-01-13 07:23:33.270113+00	2	\N
138	1381	2.0862000000000007	2026-01-13 07:23:33.270113+00	2	\N
292	1391	2.069200000000001	2026-01-13 07:23:33.270113+00	2	\N
301	1392	3.0714	2026-01-13 07:23:33.270113+00	3	\N
445	1393	3.755000000000001	2026-01-13 07:23:33.270113+00	4	\N
367	1399	3.2136	2026-01-13 07:23:33.270113+00	3	\N
330	1406	2.6916	2026-01-13 07:23:33.270113+00	3	\N
101	1409	2.2270000000000003	2026-01-13 07:23:33.270113+00	2	\N
179	1412	2.1952000000000003	2026-01-13 07:23:33.270113+00	2	\N
373	1414	2.8246	2026-01-13 07:23:33.270113+00	3	\N
150	1416	2.1248000000000005	2026-01-13 07:23:33.270113+00	2	\N
268	1419	2.0852000000000004	2026-01-13 07:23:33.270113+00	2	\N
248	1422	2.2666000000000004	2026-01-13 07:23:33.270113+00	2	\N
359	1423	2.924	2026-01-13 07:23:33.270113+00	3	\N
182	1430	2.2276000000000007	2026-01-13 07:23:33.270113+00	2	\N
460	1431	3.785200000000001	2026-01-13 07:23:33.270113+00	4	\N
293	1435	2.2622000000000004	2026-01-13 07:23:33.270113+00	2	\N
40	1437	1.523	2026-01-13 07:23:33.270113+00	1	\N
332	1442	2.773000000000001	2026-01-13 07:23:33.270113+00	3	\N
441	1444	3.6832	2026-01-13 07:23:33.270113+00	4	\N
372	1445	2.9965999999999995	2026-01-13 07:23:33.270113+00	3	\N
422	1447	2.6862000000000004	2026-01-13 07:23:33.270113+00	3	\N
393	1448	3.0912	2026-01-13 07:23:33.270113+00	3	\N
14	1451	1.729	2026-01-13 07:23:33.270113+00	1	\N
276	1452	1.9930000000000003	2026-01-13 07:23:33.270113+00	2	\N
379	1460	2.847000000000001	2026-01-13 07:23:33.270113+00	3	\N
358	1462	3.034	2026-01-13 07:23:33.270113+00	3	\N
417	1467	2.945999999999999	2026-01-13 07:23:33.270113+00	3	\N
149	1472	2.3210000000000006	2026-01-13 07:23:33.270113+00	2	\N
249	1475	2.3726000000000003	2026-01-13 07:23:33.270113+00	2	\N
469	1482	3.753000000000001	2026-01-13 07:23:33.270113+00	4	\N
125	1486	2.2226000000000004	2026-01-13 07:23:33.270113+00	2	\N
240	1488	2.202000000000001	2026-01-13 07:23:33.270113+00	2	\N
331	1489	3.2568000000000006	2026-01-13 07:23:33.270113+00	3	\N
\.


--
-- Name: answers_answer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.answers_answer_id_seq', 1, false);


--
-- Name: cluster_profiles_cluster_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cluster_profiles_cluster_id_seq', 1, false);


--
-- Name: companies_company_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.companies_company_id_seq', 1, false);


--
-- Name: dimensions_dimension_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dimensions_dimension_id_seq', 1, false);


--
-- Name: questions_question_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.questions_question_id_seq', 1, false);


--
-- Name: response_items_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.response_items_item_id_seq', 1, false);


--
-- Name: responses_response_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.responses_response_id_seq', 1, false);


--
-- Name: answers answers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (answer_id);


--
-- Name: cluster_profiles cluster_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cluster_profiles
    ADD CONSTRAINT cluster_profiles_pkey PRIMARY KEY (cluster_id);


--
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (company_id);


--
-- Name: dimensions dimensions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dimensions
    ADD CONSTRAINT dimensions_pkey PRIMARY KEY (dimension_id);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (question_id);


--
-- Name: response_items response_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.response_items
    ADD CONSTRAINT response_items_pkey PRIMARY KEY (item_id);


--
-- Name: responses responses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.responses
    ADD CONSTRAINT responses_pkey PRIMARY KEY (response_id);


--
-- Name: answers answers_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT answers_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(question_id);


--
-- Name: questions questions_dimension_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_dimension_id_fkey FOREIGN KEY (dimension_id) REFERENCES public.dimensions(dimension_id);


--
-- Name: response_items response_items_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.response_items
    ADD CONSTRAINT response_items_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(question_id);


--
-- Name: response_items response_items_response_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.response_items
    ADD CONSTRAINT response_items_response_id_fkey FOREIGN KEY (response_id) REFERENCES public.responses(response_id);


--
-- Name: responses responses_cluster_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.responses
    ADD CONSTRAINT responses_cluster_id_fkey FOREIGN KEY (cluster_id) REFERENCES public.cluster_profiles(cluster_id);


--
-- Name: responses responses_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.responses
    ADD CONSTRAINT responses_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(company_id);


--
-- Name: cluster_profiles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.cluster_profiles ENABLE ROW LEVEL SECURITY;

--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: TABLE answers; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.answers TO anon;
GRANT ALL ON TABLE public.answers TO authenticated;
GRANT ALL ON TABLE public.answers TO service_role;


--
-- Name: SEQUENCE answers_answer_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.answers_answer_id_seq TO anon;
GRANT ALL ON SEQUENCE public.answers_answer_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.answers_answer_id_seq TO service_role;


--
-- Name: TABLE cluster_profiles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.cluster_profiles TO anon;
GRANT ALL ON TABLE public.cluster_profiles TO authenticated;
GRANT ALL ON TABLE public.cluster_profiles TO service_role;


--
-- Name: SEQUENCE cluster_profiles_cluster_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.cluster_profiles_cluster_id_seq TO anon;
GRANT ALL ON SEQUENCE public.cluster_profiles_cluster_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.cluster_profiles_cluster_id_seq TO service_role;


--
-- Name: TABLE companies; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.companies TO anon;
GRANT ALL ON TABLE public.companies TO authenticated;
GRANT ALL ON TABLE public.companies TO service_role;


--
-- Name: SEQUENCE companies_company_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.companies_company_id_seq TO anon;
GRANT ALL ON SEQUENCE public.companies_company_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.companies_company_id_seq TO service_role;


--
-- Name: TABLE dimensions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.dimensions TO anon;
GRANT ALL ON TABLE public.dimensions TO authenticated;
GRANT ALL ON TABLE public.dimensions TO service_role;


--
-- Name: SEQUENCE dimensions_dimension_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.dimensions_dimension_id_seq TO anon;
GRANT ALL ON SEQUENCE public.dimensions_dimension_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.dimensions_dimension_id_seq TO service_role;


--
-- Name: TABLE questions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.questions TO anon;
GRANT ALL ON TABLE public.questions TO authenticated;
GRANT ALL ON TABLE public.questions TO service_role;


--
-- Name: SEQUENCE questions_question_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.questions_question_id_seq TO anon;
GRANT ALL ON SEQUENCE public.questions_question_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.questions_question_id_seq TO service_role;


--
-- Name: TABLE response_items; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.response_items TO anon;
GRANT ALL ON TABLE public.response_items TO authenticated;
GRANT ALL ON TABLE public.response_items TO service_role;


--
-- Name: SEQUENCE response_items_item_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.response_items_item_id_seq TO anon;
GRANT ALL ON SEQUENCE public.response_items_item_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.response_items_item_id_seq TO service_role;


--
-- Name: TABLE responses; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.responses TO anon;
GRANT ALL ON TABLE public.responses TO authenticated;
GRANT ALL ON TABLE public.responses TO service_role;


--
-- Name: SEQUENCE responses_response_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.responses_response_id_seq TO anon;
GRANT ALL ON SEQUENCE public.responses_response_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.responses_response_id_seq TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- PostgreSQL database dump complete
--

\unrestrict OftCglbVyO9z4uOnrasKbYq0DUqCtYWJ1cBySpWcvzgJr5cwWqnszmc4oUCkM8o