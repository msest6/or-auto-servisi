--
-- PostgreSQL database dump
--

\restrict ITQWQy4i18L9ZoELi81JCrsWc7Iw69W5ek3scBYjTY5bIGESaNfA9cMSdwnJiUz

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: automobil; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.automobil (
    id integer NOT NULL,
    servis_id integer NOT NULL,
    marka character varying(50) NOT NULL,
    model character varying(50) NOT NULL,
    godina_proizvodnje integer,
    vrsta_goriva character varying(20),
    snaga_kw integer,
    kilometraza integer,
    boja character varying(30),
    datum_zadnjeg_servisa date,
    CONSTRAINT automobil_godina_proizvodnje_check CHECK (((godina_proizvodnje >= 1950) AND (godina_proizvodnje <= 2100))),
    CONSTRAINT automobil_kilometraza_check CHECK ((kilometraza >= 0)),
    CONSTRAINT automobil_snaga_kw_check CHECK ((snaga_kw > 0)),
    CONSTRAINT automobil_vrsta_goriva_check CHECK (((vrsta_goriva)::text = ANY ((ARRAY['benzin'::character varying, 'dizel'::character varying, 'hibrid'::character varying, 'električni'::character varying, 'plin'::character varying])::text[])))
);


--
-- Name: automobil_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.automobil_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: automobil_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.automobil_id_seq OWNED BY public.automobil.id;


--
-- Name: servis; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.servis (
    id integer NOT NULL,
    naziv character varying(100) NOT NULL,
    grad character varying(50) NOT NULL,
    adresa character varying(150) NOT NULL,
    telefon character varying(30),
    email character varying(100),
    web_stranica character varying(150),
    godina_osnivanja integer,
    ovlasteni_za character varying(50),
    ocjena numeric(2,1),
    latitude numeric(9,6),
    longitude numeric(9,6),
    CONSTRAINT servis_godina_osnivanja_check CHECK (((godina_osnivanja >= 1900) AND (godina_osnivanja <= 2100))),
    CONSTRAINT servis_ocjena_check CHECK (((ocjena >= (1)::numeric) AND (ocjena <= (5)::numeric)))
);


--
-- Name: servis_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.servis_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: servis_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.servis_id_seq OWNED BY public.servis.id;


--
-- Name: automobil id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.automobil ALTER COLUMN id SET DEFAULT nextval('public.automobil_id_seq'::regclass);


--
-- Name: servis id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.servis ALTER COLUMN id SET DEFAULT nextval('public.servis_id_seq'::regclass);


--
-- Data for Name: automobil; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.automobil (id, servis_id, marka, model, godina_proizvodnje, vrsta_goriva, snaga_kw, kilometraza, boja, datum_zadnjeg_servisa) FROM stdin;
1	1	Volkswagen	Golf	2019	dizel	85	98500	siva	2026-09-14
2	1	Volkswagen	Passat	2017	dizel	110	176200	crna	2026-08-02
3	1	Volkswagen	ID.4	2023	električni	150	21400	bijela	2026-10-05
4	2	Opel	Astra	2014	benzin	74	201300	plava	2026-07-21
5	2	Fiat	Punto	2011	benzin	51	158900	crvena	2026-06-11
6	2	Ford	Focus	2018	dizel	88	134700	srebrna	2026-09-30
7	3	Toyota	Yaris	2021	hibrid	85	45200	bijela	2026-10-12
8	3	Toyota	Corolla	2020	hibrid	90	67800	siva	2026-05-19
9	3	Toyota	RAV4	2022	hibrid	163	38900	zelena	2026-09-03
10	3	Toyota	Aygo X	2023	benzin	53	12300	crvena	2026-08-27
11	4	Peugeot	308	2016	dizel	88	187400	crna	2026-04-08
12	4	Citroën	C3	2019	benzin	61	76500	narančasta	2026-09-22
13	4	Mazda	CX-5	2018	benzin	121	112300	crvena	2026-07-15
14	5	Škoda	Octavia	2020	dizel	110	142600	siva	2026-10-01
15	5	Škoda	Fabia	2018	benzin	70	89300	plava	2026-06-25
16	5	Škoda	Kodiaq	2022	dizel	147	54100	crna	2026-08-18
17	6	Renault	Clio	2019	benzin	67	71200	bijela	2026-09-09
18	6	Renault	Megane	2017	dizel	81	165800	siva	2026-03-30
19	6	Dacia	Duster	2021	plin	74	58700	smeđa	2026-07-04
20	7	Audi	A4	2015	dizel	110	223500	crna	2026-10-20
21	7	Kia	Ceed	2020	benzin	88	64900	srebrna	2026-08-11
22	7	Volkswagen	Polo	2013	benzin	55	176000	žuta	2026-05-06
23	8	Hyundai	i30	2019	benzin	88	83400	plava	2026-09-17
24	8	Hyundai	Tucson	2022	hibrid	169	31700	siva	2026-10-08
25	8	Hyundai	Kona	2023	električni	150	18200	bijela	2026-07-29
26	9	BMW	320d	2019	dizel	140	128900	crna	2026-09-25
27	9	BMW	X3	2021	hibrid	215	49600	bijela	2026-06-14
28	9	BMW	i4	2023	električni	250	15800	plava	2026-10-16
29	10	Seat	Leon	2016	dizel	85	192100	crvena	2026-04-23
30	10	Nissan	Qashqai	2018	benzin	103	118400	siva	2026-08-06
31	10	Suzuki	Vitara	2020	hibrid	95	61300	zelena	2026-09-12
\.


--
-- Data for Name: servis; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.servis (id, naziv, grad, adresa, telefon, email, web_stranica, godina_osnivanja, ovlasteni_za, ocjena, latitude, longitude) FROM stdin;
1	Auto Centar Horvat	Zagreb	Slavonska avenija 52	+385 1 6110 234	info@ac-horvat.hr	www.ac-horvat.hr	1998	Volkswagen	4.6	45.800210	15.995330
2	Servis Kovačević	Zagreb	Zagrebačka cesta 145	+385 1 3820 117	servis@kovacevic.hr	www.kovacevic.hr	2005	sve marke	4.2	45.806120	15.931870
3	Jadran Motors	Split	Domovinskog rata 88	+385 21 470 520	info@jadranmotors.hr	www.jadranmotors.hr	2001	Toyota	4.7	43.521840	16.462190
4	Autoservis Babić	Rijeka	Zvonimirova 41	+385 51 330 418	babic@autoservis-ri.hr	\N	1992	sve marke	4.0	45.337060	14.427370
5	Drava Auto	Osijek	Vukovarska cesta 210	+385 31 505 300	kontakt@drava-auto.hr	www.drava-auto.hr	2010	Škoda	4.4	45.548910	18.719420
6	Auto Kuća Perić	Zadar	Put Murvice 12	+385 23 312 905	info@autokuca-peric.hr	www.autokuca-peric.hr	2008	Renault	4.1	44.124150	15.244470
7	Mehanika Novak	Varaždin	Zagrebačka 96	+385 42 211 640	novak@mehanika.hr	\N	2015	sve marke	4.8	46.296310	16.322580
8	Istra Car Servis	Pula	Šijanska cesta 30	+385 52 380 777	servis@istracar.hr	www.istracar.hr	2003	Hyundai	4.3	44.864920	13.866450
9	Bavaria Auto Centar	Zagreb	Radnička cesta 180	+385 1 6040 900	info@bavaria-ac.hr	www.bavaria-ac.hr	2012	BMW	4.5	45.795760	16.004900
10	Slavonija Servis	Slavonski Brod	Ulica Ivana Gundulića 7	+385 35 445 120	info@slavonija-servis.hr	\N	1999	sve marke	3.9	45.160070	18.015330
\.


--
-- Name: automobil_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.automobil_id_seq', 31, true);


--
-- Name: servis_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.servis_id_seq', 10, true);


--
-- Name: automobil automobil_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.automobil
    ADD CONSTRAINT automobil_pkey PRIMARY KEY (id);


--
-- Name: servis servis_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.servis
    ADD CONSTRAINT servis_pkey PRIMARY KEY (id);


--
-- Name: idx_automobil_servis; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_automobil_servis ON public.automobil USING btree (servis_id);


--
-- Name: automobil automobil_servis_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.automobil
    ADD CONSTRAINT automobil_servis_id_fkey FOREIGN KEY (servis_id) REFERENCES public.servis(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict ITQWQy4i18L9ZoELi81JCrsWc7Iw69W5ek3scBYjTY5bIGESaNfA9cMSdwnJiUz

