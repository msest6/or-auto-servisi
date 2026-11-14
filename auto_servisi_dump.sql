--
-- PostgreSQL database dump
--

\restrict DutMeDoZyWIiuR61yvXmT8BPzVgcOQqAMoLJ3XYGkdBcBd6C6xTeA6Ic4XOqDd4

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

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS '';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: automobil; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.automobil (
    id integer NOT NULL,
    registracija character varying(15) NOT NULL,
    marka character varying(50) NOT NULL,
    model character varying(50) NOT NULL,
    godina_proizvodnje integer,
    vrsta_goriva character varying(20),
    snaga_kw integer,
    boja character varying(30),
    CONSTRAINT automobil_godina_proizvodnje_check CHECK (((godina_proizvodnje >= 1950) AND (godina_proizvodnje <= 2100))),
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
    centar_id integer NOT NULL,
    automobil_id integer NOT NULL,
    datum date NOT NULL,
    vrsta_usluge character varying(30) NOT NULL,
    mehanicar character varying(100) NOT NULL,
    kilometraza integer,
    cijena_eur numeric(8,2),
    opis character varying(300),
    CONSTRAINT servis_cijena_eur_check CHECK ((cijena_eur >= (0)::numeric)),
    CONSTRAINT servis_kilometraza_check CHECK ((kilometraza >= 0)),
    CONSTRAINT servis_vrsta_usluge_check CHECK (((vrsta_usluge)::text = ANY ((ARRAY['mali servis'::character varying, 'veliki servis'::character varying, 'zamjena guma'::character varying, 'dijagnostika'::character varying, 'popravak kočnica'::character varying, 'klima servis'::character varying, 'tehnički pregled'::character varying])::text[])))
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
-- Name: servisni_centar; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.servisni_centar (
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
    CONSTRAINT servisni_centar_godina_osnivanja_check CHECK (((godina_osnivanja >= 1900) AND (godina_osnivanja <= 2100))),
    CONSTRAINT servisni_centar_ocjena_check CHECK (((ocjena >= (1)::numeric) AND (ocjena <= (5)::numeric)))
);


--
-- Name: servisni_centar_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.servisni_centar_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: servisni_centar_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.servisni_centar_id_seq OWNED BY public.servisni_centar.id;


--
-- Name: automobil id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.automobil ALTER COLUMN id SET DEFAULT nextval('public.automobil_id_seq'::regclass);


--
-- Name: servis id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.servis ALTER COLUMN id SET DEFAULT nextval('public.servis_id_seq'::regclass);


--
-- Name: servisni_centar id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.servisni_centar ALTER COLUMN id SET DEFAULT nextval('public.servisni_centar_id_seq'::regclass);


--
-- Data for Name: automobil; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.automobil (id, registracija, marka, model, godina_proizvodnje, vrsta_goriva, snaga_kw, boja) FROM stdin;
1	ZG-1234-AB	Volkswagen	Golf	2019	dizel	85	siva
2	ZG-5678-CD	Volkswagen	Passat	2017	dizel	110	crna
3	ZG-9012-EF	Opel	Astra	2014	benzin	74	plava
4	ZG-3456-GH	BMW	320d	2019	dizel	140	crna
5	ZG-7890-IJ	BMW	X3	2021	hibrid	215	bijela
6	ST-1122-KL	Toyota	Yaris	2021	hibrid	85	bijela
7	ST-3344-MN	Toyota	RAV4	2022	hibrid	163	zelena
8	ST-5566-OP	Renault	Clio	2019	benzin	67	bijela
9	RI-7788-RS	Peugeot	308	2016	dizel	88	crna
10	RI-9900-TU	Mazda	CX-5	2018	benzin	121	crvena
11	PU-2468-VZ	Hyundai	Tucson	2022	hibrid	169	siva
12	PU-1357-AA	Hyundai	Kona	2023	električni	150	bijela
13	OS-8642-BB	Škoda	Octavia	2020	dizel	110	siva
14	OS-9753-CC	Škoda	Kodiaq	2022	dizel	147	crna
15	ZD-1928-DD	Dacia	Duster	2021	plin	74	smeđa
16	ZD-3746-EE	Renault	Megane	2017	dizel	81	siva
17	VŽ-5182-FF	Audi	A4	2015	dizel	110	crna
18	VŽ-6293-GG	Kia	Ceed	2020	benzin	88	srebrna
19	SB-7314-HH	Nissan	Qashqai	2018	benzin	103	siva
20	SB-8425-II	Seat	Leon	2016	dizel	85	crvena
\.


--
-- Data for Name: servis; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.servis (id, centar_id, automobil_id, datum, vrsta_usluge, mehanicar, kilometraza, cijena_eur, opis) FROM stdin;
1	1	1	2025-09-10	veliki servis	Ivan Horvat	82300	420.00	Zamjena zupčastog remena i pumpe za vodu
2	1	1	2026-09-14	mali servis	Marko Jurić	98500	185.00	Ulje, filter ulja i filter zraka
3	1	2	2026-08-02	popravak kočnica	Ivan Horvat	176200	310.00	Prednji diskovi i pločice
4	1	17	2026-03-18	dijagnostika	Marko Jurić	215800	60.00	Greška senzora tlaka turbine
5	2	3	2026-07-21	mali servis	Tomislav Kovačević	201300	140.00	Ulje i filteri
6	2	3	2026-10-28	zamjena guma	Ante Marić	204100	40.00	Montaža zimskih guma
7	2	1	2026-04-03	zamjena guma	Ante Marić	91200	40.00	Montaža ljetnih guma
8	2	4	2026-10-30	zamjena guma	Tomislav Kovačević	131500	45.00	Montaža zimskih guma
9	2	2	2026-06-15	klima servis	Ante Marić	172900	75.00	Punjenje klime i dezinfekcija
10	3	6	2026-10-12	mali servis	Josip Bašić	45200	160.00	Redovni servis prema knjižici
11	3	7	2025-09-01	mali servis	Luka Radić	22100	175.00	Prvi redovni servis
12	3	7	2026-09-03	veliki servis	Josip Bašić	38900	390.00	Servis hibridnog sustava
13	3	8	2026-05-20	zamjena guma	Luka Radić	68400	35.00	Montaža ljetnih guma
14	4	9	2026-04-08	veliki servis	Dario Babić	187400	450.00	Zamjena remena i spojke
15	4	10	2026-07-15	mali servis	Nikola Vuković	112300	150.00	Ulje i filteri
16	4	10	2026-02-11	tehnički pregled	Dario Babić	106900	55.00	Priprema za tehnički pregled
17	5	13	2025-10-02	mali servis	Filip Šimić	118900	170.00	Redovni servis prema knjižici
18	5	13	2026-10-01	veliki servis	Krešimir Knežević	142600	410.00	Zamjena zupčastog remena
19	5	14	2026-08-18	mali servis	Filip Šimić	54100	190.00	Ulje, filteri i AdBlue
20	5	19	2026-06-09	dijagnostika	Krešimir Knežević	115200	50.00	Provjera rada ABS-a
21	6	8	2026-09-09	mali servis	Mate Perić	71200	145.00	Redovni servis prema knjižici
22	6	16	2026-03-30	popravak kočnica	Stipe Kalinić	165800	260.00	Stražnje pločice i ručna kočnica
23	6	15	2026-07-04	mali servis	Mate Perić	58700	155.00	Servis i provjera plinske instalacije
24	6	15	2026-10-22	zamjena guma	Stipe Kalinić	62300	35.00	Montaža zimskih guma
25	7	17	2026-10-20	veliki servis	Matija Novak	223500	480.00	Zamjena turbine i ulja
26	7	18	2026-08-11	mali servis	Hrvoje Golub	64900	135.00	Ulje i filteri
27	7	18	2026-05-14	klima servis	Matija Novak	61800	70.00	Punjenje klime
28	8	11	2026-10-08	mali servis	Marin Brajković	31700	180.00	Redovni servis prema knjižici
29	8	12	2026-07-29	dijagnostika	Dino Sanković	18200	45.00	Provjera baterije i softvera
30	8	9	2026-08-24	klima servis	Dino Sanković	190100	80.00	Zamjena filtera kabine i punjenje klime
31	9	4	2026-09-25	mali servis	Petar Lovrić	128900	260.00	Ulje, filteri i ažuriranje softvera
32	9	4	2025-09-19	popravak kočnica	Igor Pavić	104600	380.00	Prednji diskovi i pločice
33	9	5	2026-06-14	veliki servis	Petar Lovrić	49600	520.00	Servis hibridnog sustava i kočnica
34	10	20	2026-04-23	veliki servis	Zoran Matić	192100	430.00	Zamjena zupčastog remena i spojke
35	10	19	2026-08-06	mali servis	Damir Filipović	118400	140.00	Ulje i filteri
36	10	13	2026-01-27	zamjena guma	Zoran Matić	128300	40.00	Zamjena oštećene zimske gume
37	10	20	2026-10-26	tehnički pregled	Damir Filipović	197800	55.00	Priprema za tehnički pregled
\.


--
-- Data for Name: servisni_centar; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.servisni_centar (id, naziv, grad, adresa, telefon, email, web_stranica, godina_osnivanja, ovlasteni_za, ocjena, latitude, longitude) FROM stdin;
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

SELECT pg_catalog.setval('public.automobil_id_seq', 20, true);


--
-- Name: servis_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.servis_id_seq', 37, true);


--
-- Name: servisni_centar_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.servisni_centar_id_seq', 10, true);


--
-- Name: automobil automobil_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.automobil
    ADD CONSTRAINT automobil_pkey PRIMARY KEY (id);


--
-- Name: automobil automobil_registracija_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.automobil
    ADD CONSTRAINT automobil_registracija_key UNIQUE (registracija);


--
-- Name: servis servis_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.servis
    ADD CONSTRAINT servis_pkey PRIMARY KEY (id);


--
-- Name: servisni_centar servisni_centar_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.servisni_centar
    ADD CONSTRAINT servisni_centar_pkey PRIMARY KEY (id);


--
-- Name: idx_servis_automobil; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_servis_automobil ON public.servis USING btree (automobil_id);


--
-- Name: idx_servis_centar; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_servis_centar ON public.servis USING btree (centar_id);


--
-- Name: servis servis_automobil_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.servis
    ADD CONSTRAINT servis_automobil_id_fkey FOREIGN KEY (automobil_id) REFERENCES public.automobil(id) ON DELETE CASCADE;


--
-- Name: servis servis_centar_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.servis
    ADD CONSTRAINT servis_centar_id_fkey FOREIGN KEY (centar_id) REFERENCES public.servisni_centar(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict DutMeDoZyWIiuR61yvXmT8BPzVgcOQqAMoLJ3XYGkdBcBd6C6xTeA6Ic4XOqDd4

