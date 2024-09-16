--1
CREATE SEQUENCE seq_id_pomieszczenia
minvalue 1
maxvalue 99
start with 1
nocycle
increment by 1;

CREATE TABLE POMIESZCZENIA 
(
    id_pomieszczenia NUMBER(2) CONSTRAINT id_pomieszczenia_pk PRIMARY KEY,
    nazwa_pomieszczenia VARCHAR(30) CONSTRAINT nazwa_pomieszczenia_nn NOT NULL
);
--2
CREATE SEQUENCE seq_id_schowka
minvalue 1
maxvalue 999
start with 1
nocycle
increment by 1;

CREATE TABLE SCHOWKI 
(
    id_schowka NUMBER(3) CONSTRAINT id_schowka_pk PRIMARY KEY,
    nazwa_schowka VARCHAR(30) CONSTRAINT nazwa_schowka_nn NOT NULL,
    id_pomieszczenia NUMBER(2)
);
ALTER TABLE SCHOWKI ADD CONSTRAINT id_pomieszczenia_fk FOREIGN KEY (id_pomieszczenia) REFERENCES POMIESZCZENIA(id_pomieszczenia);
--3
CREATE SEQUENCE seq_id_pojemnika
minvalue 1
maxvalue 9999
start with 1
nocycle
increment by 1;

CREATE TABLE POJEMNIKI 
(
    id_pojemnika NUMBER(4) CONSTRAINT id_pojemnika_pk PRIMARY KEY,
    nazwa_pojemnika VARCHAR(30) CONSTRAINT nazwa_pojemnika_nn NOT NULL,
    id_schowka NUMBER(3)
);
ALTER TABLE POJEMNIKI ADD CONSTRAINT id_schowka_fk FOREIGN KEY (id_schowka) REFERENCES SCHOWKI(id_schowka);
--4
CREATE SEQUENCE seq_id_typu_akumulatora
minvalue 1
maxvalue 999
start with 1
nocycle
increment by 1;

CREATE TABLE TYPY_AKUMULATOROW 
(
    id_typu_akumulatora NUMBER(3) CONSTRAINT id_typu_akumulatora_pk PRIMARY KEY,
    symbol VARCHAR(30) CONSTRAINT symbol_nn NOT NULL,
    napiecie_v NUMBER (5,1) CONSTRAINT napiecie_v_nn NOT NULL,
    temp_min_c DECIMAL(5,1) CONSTRAINT temp_min_c_nn NOT NULL,
    CONSTRAINT temp_min_c_ch CHECK (temp_min_c < temp_max_c),
    temp_max_c DECIMAL(5,1) CONSTRAINT temp_max_c_nn NOT NULL,
    CONSTRAINT temp_max_c_ch CHECK (temp_min_c < temp_max_c),
    ogniwa NUMBER (3) DEFAULT 1
);
--5
CREATE SEQUENCE seq_id_akumulatora
minvalue 1
maxvalue 9999
start with 1
nocycle
increment by 1;

CREATE TABLE AKUMULATORY 
(
    id_akumulatora NUMBER(4) CONSTRAINT id_akumulatora_pk PRIMARY KEY,
    typ_akumulatora NUMBER(3) CONSTRAINT typ_akumulatora_nn NOT NULL,
    waga_kg NUMBER (6,3) CONSTRAINT waga_kg_nn NOT NULL,
    pojemnosc_ah NUMBER(9,3) CONSTRAINT pojemnosc_ah_nn NOT NULL,
    cykle_ladowania NUMBER(5) CONSTRAINT cykle_ladowania_nn NOT NULL,
    stan NUMBER(3) CONSTRAINT stan_ch CHECK (stan < 101),
    id_pojemnika NUMBER(4) 
);
ALTER TABLE AKUMULATORY ADD CONSTRAINT typ_akumulatora_fk FOREIGN KEY (typ_akumulatora)
    REFERENCES TYPY_AKUMULATOROW(id_typu_akumulatora);
ALTER TABLE AKUMULATORY ADD CONSTRAINT id_pojemnika_fk FOREIGN KEY (id_pojemnika) REFERENCES POJEMNIKI(id_pojemnika);
--6
CREATE SEQUENCE seq_id_pojazdu
minvalue 1
maxvalue 99
start with 1
nocycle
increment by 1;

CREATE TABLE POJAZDY 
(
    id_pojazdu NUMBER(2) CONSTRAINT id_pojazdu_pk PRIMARY KEY,
    nazwa VARCHAR(25) CONSTRAINT nazwa_nn NOT NULL,
    data_produkcji DATE default(sysdate),
    masa_kg NUMBER(6,1) CONSTRAINT masa_kg_nn NOT NULL,
    w_uzyciu NUMBER (1) default(0),
    ostatnio_uzyty DATE,
    typ_akumulatora NUMBER(3),
    id_akumulatora NUMBER(4)
);
ALTER TABLE POJAZDY ADD CONSTRAINT typ_akumulatora_fk6 FOREIGN KEY (typ_akumulatora) REFERENCES TYPY_AKUMULATOROW(id_typu_akumulatora);
ALTER TABLE POJAZDY ADD CONSTRAINT id_akumulatora_fk6 FOREIGN KEY (id_akumulatora) REFERENCES AKUMULATORY(id_akumulatora);

--7
CREATE SEQUENCE seq_id_czesci
minvalue 1
maxvalue 999
start with 1
nocycle
increment by 1;

CREATE TABLE CZESCI 
(
    id_czesci NUMBER(3) CONSTRAINT id_czesci_pk PRIMARY KEY,
    kod VARCHAR(15) default('brak_kodu'),
    nazwa VARCHAR(100) CONSTRAINT nazwa_nn7 NOT NULL,
    id_pojazdu NUMBER(2) default(NULL),
    id_pojemnika NUMBER(4)
);
ALTER TABLE CZESCI ADD CONSTRAINT id_pojazdu_fk7 FOREIGN KEY (id_pojazdu) REFERENCES POJAZDY(id_pojazdu);
ALTER TABLE CZESCI ADD CONSTRAINT id_pojemnika_fk7 FOREIGN KEY (id_pojemnika) REFERENCES POJEMNIKI(id_pojemnika);

--8
CREATE SEQUENCE seq_id_ekspedycji
minvalue 1
maxvalue 99999
start with 1
nocycle
increment by 1;

CREATE TABLE EKSPEDYCJE 
(
    id_ekspedycji NUMBER(5) CONSTRAINT id_ekspedycji_pk PRIMARY KEY,
    tytul VARCHAR(200),
    cel VARCHAR(300),
    data_rozpoczecia DATE DEFAULT(SYSDATE),
    data_zakonczenia DATE,
    id_pojazdu NUMBER(2)
);
ALTER TABLE EKSPEDYCJE ADD CONSTRAINT id_pojazdu_fk8 FOREIGN KEY (id_pojazdu) REFERENCES POJAZDY(id_pojazdu);

--9
CREATE SEQUENCE seq_id_wspolzedne
minvalue 1
maxvalue 9999999999
start with 1
nocycle
increment by 1;

CREATE TABLE WSPOLZEDNE 
(
    id_wspolzedne NUMBER(10) CONSTRAINT id_wspolzedne_pk PRIMARY KEY,
    id_ekspedycji NUMBER(5) NOT NULL,
    data_wpisu TIMESTAMP NOT NULL,
    lat DECIMAL(16,12) NOT NULL,
    lng DECIMAL(16,12) NOT NULL
);
ALTER TABLE WSPOLZEDNE ADD CONSTRAINT id_ekspedycji_fk9 FOREIGN KEY (id_ekspedycji) REFERENCES EKSPEDYCJE(id_ekspedycji);
--10
CREATE SEQUENCE seq_id_narzedzia
minvalue 1
maxvalue 9999
start with 1
nocycle
increment by 1;

CREATE TABLE NARZEDZIA 
(
    id_narzedzia NUMBER(4) CONSTRAINT id_narzedzia_pk PRIMARY KEY,
    nazwa VARCHAR(40) NOT NULL,
    id_pojemnika NUMBER(4)
);
ALTER TABLE NARZEDZIA ADD CONSTRAINT id_pojemnika_fk10 FOREIGN KEY (id_pojemnika) REFERENCES POJEMNIKI(id_pojemnika);

--11
CREATE SEQUENCE seq_id_wyposazenie
minvalue 1
maxvalue 999999
start with 1
nocycle
increment by 1;

CREATE TABLE WYPOSAZENIE 
(
    id_wyposazenia NUMBER(6) CONSTRAINT id_wyposazenia_fk PRIMARY KEY,
    id_ekspedycji NUMBER(5) NOT NULL,
    id_narzedzia NUMBER(4) NOT NULL
);
ALTER TABLE WYPOSAZENIE ADD CONSTRAINT id_ekspedycji_fk11 FOREIGN KEY (id_ekspedycji) REFERENCES EKSPEDYCJE(id_ekspedycji);
ALTER TABLE WYPOSAZENIE ADD CONSTRAINT id_narzedzia_fk11 FOREIGN KEY (id_narzedzia) REFERENCES NARZEDZIA(id_narzedzia);



---- INSERTY
--- Tabela Pomieszczenia
INSERT INTO POMIESZCZENIA VALUES (seq_id_pomieszczenia.nextval , 'Magazyn_glowny');
INSERT INTO POMIESZCZENIA VALUES (seq_id_pomieszczenia.nextval , 'Magazyn_pomocniczy');
INSERT INTO POMIESZCZENIA VALUES (seq_id_pomieszczenia.nextval , 'Kuchnia');
INSERT INTO POMIESZCZENIA VALUES (seq_id_pomieszczenia.nextval , 'Sypialnia');
INSERT INTO POMIESZCZENIA VALUES (seq_id_pomieszczenia.nextval , 'Garaz');
INSERT INTO POMIESZCZENIA VALUES (seq_id_pomieszczenia.nextval , 'Pomieszczenie_sanitarne_');
INSERT INTO POMIESZCZENIA VALUES (seq_id_pomieszczenia.nextval , 'Pomieszczenie_Komputerowe');

select * from POMIESZCZENIA;

--- Tabela Schowki
INSERT INTO SCHOWKI VALUES (seq_id_schowka.nextval , 'Regal_sprzet_komputerowy' , 1); --1
INSERT INTO SCHOWKI VALUES (seq_id_schowka.nextval , 'Regal_narzedzia' , 1); --2
INSERT INTO SCHOWKI VALUES (seq_id_schowka.nextval , 'Regal_nasiona' , 1); --3
INSERT INTO SCHOWKI VALUES (seq_id_schowka.nextval , 'Regal_Zasilanie' , 1); --4
INSERT INTO SCHOWKI VALUES (seq_id_schowka.nextval , 'Regal_nr5' , 1); --5
INSERT INTO SCHOWKI VALUES (seq_id_schowka.nextval , 'Regal_literatura' , 2); --6
INSERT INTO SCHOWKI VALUES (seq_id_schowka.nextval , 'Regal_zapasowy_sprzet_komputerowy' , 2); --7
INSERT INTO SCHOWKI VALUES (seq_id_schowka.nextval , 'Regal_nr3' , 2); --8
INSERT INTO SCHOWKI VALUES (seq_id_schowka.nextval , 'Regal_racje_zywnosciowe' , 3); --9
INSERT INTO SCHOWKI VALUES (seq_id_schowka.nextval , 'Regal_przyprawy' , 3); --10
INSERT INTO SCHOWKI VALUES (seq_id_schowka.nextval , 'Regal_dodatki' , 3); --11
INSERT INTO SCHOWKI VALUES (seq_id_schowka.nextval , 'szafka_mieszkanca_nr1' ,4); --12
INSERT INTO SCHOWKI VALUES (seq_id_schowka.nextval , 'szafka_mieszkanca_nr2' ,4); --13
INSERT INTO SCHOWKI VALUES (seq_id_schowka.nextval , 'szafka_mieszkanca_nr3' ,4); --14
INSERT INTO SCHOWKI VALUES (seq_id_schowka.nextval , 'szafka_mieszkanca_nr4' ,4); --15
INSERT INTO SCHOWKI VALUES (seq_id_schowka.nextval , 'szafka_mieszkanca_nr5' ,4); --16
INSERT INTO SCHOWKI VALUES (seq_id_schowka.nextval , 'miejsca_parkingowe' ,5); --17
INSERT INTO SCHOWKI VALUES (seq_id_schowka.nextval , 'regal_czesci_zamienne_1' ,5); --18
INSERT INTO SCHOWKI VALUES (seq_id_schowka.nextval , 'regal_czesci_zamienne_2' ,5); --19
INSERT INTO SCHOWKI VALUES (seq_id_schowka.nextval , 'narzedzia_naprawcze' ,5); --20
INSERT INTO SCHOWKI VALUES (seq_id_schowka.nextval , 'regal_narzedzia_chirurgiczne' ,6); --21
INSERT INTO SCHOWKI VALUES (seq_id_schowka.nextval , 'regal_opatrunki' ,6); --22
INSERT INTO SCHOWKI VALUES (seq_id_schowka.nextval , 'regal_lekarstwa' ,6); --23
INSERT INTO SCHOWKI VALUES (seq_id_schowka.nextval , 'regal_srodki_higieniczne' ,6); --24
INSERT INTO SCHOWKI VALUES (seq_id_schowka.nextval , 'regal_Urządzenie peryferyjne' ,7); --25
INSERT INTO SCHOWKI VALUES (seq_id_schowka.nextval , 'regal_okablowanie' ,7);  --26

select * from SCHOWKI;

--TAbela Pojemniki
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_laptopy' ,1); --1
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_komputery_stacjarne' ,1); --2
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_dyski_twarde' ,1); --3
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'narzędzia_codziennego_uzytku' ,2); --4
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'narzędzia_ogrodniczne' ,2); --5
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'narzędzia_naprawcze' ,2); --6
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'nasiona_jadalne' , 3); --7
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'nasiona_przypraw' , 3); --8
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'baterie' , 4); --9
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'akumulatory' , 4); --10
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'ksiazki_fizyka' , 6); --11
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'ksiazki_chemia' , 6); --12
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'ksiazki_matematyka' , 6); --13
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'ksiazki_powiesci' , 6); --14
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_laptopy' , 7); --15
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_dyski_twarde' , 7); --16
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_posilki' , 9); --17
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_napoje' , 9); --18
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_przyprawy_stale' , 10); --19
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_przyprawy_ciecze' , 10); --20
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_dodatki_slone' , 11); --21
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_dodatki_slodkie' , 11); --22
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_ubrania' , 12); --23
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_rzeczy_osobiste' , 12); --24
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_kosmetyczka' , 12); --25
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_ubrania' , 13); --26
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_rzeczy_osobiste' , 13);  --27
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_kosmetyczka' , 13); --28
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_ubrania' , 14); --29
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_rzeczy_osobiste' , 14);  --30
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_kosmetyczka' , 14); --31
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_ubrania' , 15); --32
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_rzeczy_osobiste' , 15); --33
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_kosmetyczka' , 15); --34
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_ubrania' , 16); --35
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_rzeczy_osobiste' , 16); --36
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_kosmetyczka' , 16); --37
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojazdy_zalogowe' , 17); --38
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojazdy_bezzalogowe' , 17);  --39
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'czesci_wewnetrzne' , 17); --40
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'czesci_zewnętrzne' , 17); --41
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'ogumienie' , 18); --42
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'naprawcze' , 20);
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pomiarowe' , 20);
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'metalowe' , 21);
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'szklane' , 21);
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'opatrunki_gazowe' , 22);
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'opaturnki_uciskowe' , 22);
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'lekarstwa_stale' , 23);
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'lekarstwa_ciecze' , 23);
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_preparaty_higieniczne' , 24);
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_sprzety_do_higieny' , 24);
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_obsluga_komputera' , 25);
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_dzwiek' , 25);
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_obraz' , 25);
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_kable_zasilajace' , 26);
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_kable_dzwiek' , 26);
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_kable_obraz' , 26);
INSERT INTO POJEMNIKI  VALUES (seq_id_pojemnika.nextval , 'pojemnik_kable_pozostale' , 26);

select * from POJEMNIKI;

--- Tabela TYPY_AKUMULATOROW
INSERT INTO  TYPY_AKUMULATOROW  VALUES (seq_id_typu_akumulatora.nextval , 'akumulator15V' , 15 , -20 , 50 , 1);
INSERT INTO  TYPY_AKUMULATOROW  VALUES (seq_id_typu_akumulatora.nextval , 'akumulator150V' , 150 , -5 , 10 , 20 );
INSERT INTO  TYPY_AKUMULATOROW  VALUES (seq_id_typu_akumulatora.nextval , 'akumulator50V' , 50 , -50 , 20 , 10 );
INSERT INTO  TYPY_AKUMULATOROW  VALUES (seq_id_typu_akumulatora.nextval , 'akumulator40V' , 40 , -100 , 50 , 8 );
INSERT INTO  TYPY_AKUMULATOROW  VALUES (seq_id_typu_akumulatora.nextval , 'akumulator30V' , 30 , -20 , 50 , 2 );
INSERT INTO  TYPY_AKUMULATOROW  VALUES (seq_id_typu_akumulatora.nextval , 'baterieAA' , 1.5 , -20 , 50 , 1 );
INSERT INTO  TYPY_AKUMULATOROW  VALUES (seq_id_typu_akumulatora.nextval , 'Bateria_do_GoPro' , 5, -20 , 50 , 1 );
INSERT INTO  TYPY_AKUMULATOROW  VALUES (seq_id_typu_akumulatora.nextval , 'bateria_drona*_v5' , 15 , -30 , 40 , 2 );

SELECT * FROM TYPY_AKUMULATOROW;

--- Tabela Akumulatory

INSERT INTO AKUMULATORY   VALUES (seq_id_akumulatora.nextval , 1 , 10 , 150000 , 3 , 10 , 10  );
INSERT INTO AKUMULATORY   VALUES (seq_id_akumulatora.nextval , 2 , 50 , 500000 , 8 , 70 , 10  );
INSERT INTO AKUMULATORY   VALUES (seq_id_akumulatora.nextval , 3 , 30 , 300000 , 5 , 32 , 10  );
INSERT INTO AKUMULATORY   VALUES (seq_id_akumulatora.nextval , 4 , 25 , 250000 , 1 , 55 , 10  );
INSERT INTO AKUMULATORY   VALUES (seq_id_akumulatora.nextval , 5 , 20 , 150000 , 3 , 21 , 10  );

SELECT * FROM AKUMULATORY; 

-- Tabela Pojazdy

INSERT INTO POJAZDY VALUES (seq_id_pojazdu.nextval,'Mars Exploration Rover-A' , TO_DATE('24-02-2004','DD-MM-YYYY') , 185 , 1 , TO_DATE('24-05-2011','DD-MM-YYYY') , 2 , 2 );
INSERT INTO POJAZDY VALUES (seq_id_pojazdu.nextval,'Perseverance' , TO_DATE('01-01-2020','DD-MM-YYYY') , 1025 , 1 , TO_DATE('18-02-2021','DD-MM-YYYY') , 5 , 5 );
INSERT INTO POJAZDY VALUES (seq_id_pojazdu.nextval,'MARTIAN' , TO_DATE('13-05-2021','DD-MM-YYYY') , 1511 , 1 , TO_DATE('18-10-2021','DD-MM-YYYY') , 3, 3 );
INSERT INTO POJAZDY VALUES (seq_id_pojazdu.nextval,'Batmobile' , TO_DATE('20-01-2021','DD-MM-YYYY') , 1711 , 1 ,  TO_DATE('18-5-2021','DD-MM-YYYY') , 2, 2 );
INSERT INTO POJAZDY VALUES (seq_id_pojazdu.nextval,'PrOP-M' , TO_DATE('09-09-1970','DD-MM-YYYY') , 5 , 0 ,  TO_DATE('12-12-1971','DD-MM-YYYY') , 1,1);

SELECT * FROM POJAZDY;
---Tabela Czesci
INSERT INTO CZESCI VALUES (seq_id_czesci.nextval,'brak_kodu' , 'OPONA_BATMOBIL', 4 , 42);
INSERT INTO CZESCI VALUES (seq_id_czesci.nextval,'brak_kodu' , 'Opona_Perseverance', 2 , 42);
INSERT INTO CZESCI VALUES (seq_id_czesci.nextval,'brak_kodu' , 'Opona_Mars_Exploration Rover-A', 1 , 42);
INSERT INTO CZESCI VALUES (seq_id_czesci.nextval,'brak_kodu' , 'MARTIAN', 3 , 42);
INSERT INTO CZESCI VALUES (seq_id_czesci.nextval,'brak_kodu' , 'SILNIK_BATMOBIL', 4 , 40);
INSERT INTO CZESCI VALUES (seq_id_czesci.nextval,'brak_kodu' , 'ANTENA_Perseverance', 2 , 41);
INSERT INTO CZESCI VALUES (seq_id_czesci.nextval,'brak_kodu' , 'SILNIK_Mars_Exploration Rover-A', 1 , 40);
INSERT INTO CZESCI VALUES (seq_id_czesci.nextval,'brak_kodu' , 'Kamera_Mars_Exploration Rover-A', 1 , 41);
INSERT INTO CZESCI VALUES (seq_id_czesci.nextval,'brak_kodu' , 'Kamera_Perseverance', 2 , 41);
INSERT INTO CZESCI VALUES (seq_id_czesci.nextval,'brak_kodu' , 'Panel_Sloneczny_Mars_Exploration Rover-A', 1 , 41);
INSERT INTO CZESCI VALUES (seq_id_czesci.nextval,'brak_kodu' , 'Fotel_BATMOBIL', 4 , 41);
SELECT * FROM CZESCI;

--Tabela Ekspedycje
INSERT INTO EKSPEDYCJE  VALUES (seq_id_ekspedycji.nextval , 'Probkowanie' , 'Pobranie probek gleby z marsa', TO_DATE('20-07-2019','DD-MM-YYYY') , TO_DATE('25-10-2021','DD-MM-YYYY') , 2  );
INSERT INTO EKSPEDYCJE  VALUES (seq_id_ekspedycji.nextval , 'Woda' , 'Poszukiwanie wody', TO_DATE('20-08-2014','DD-MM-YYYY') , TO_DATE('15-03-2010','DD-MM-YYYY') , 1 );
INSERT INTO EKSPEDYCJE  VALUES (seq_id_ekspedycji.nextval , 'pierwsza misja' , 'Sprawdzenie transportu lazika na marsa', TO_DATE('20-12-1971','DD-MM-YYYY') , TO_DATE('20-05-1972','DD-MM-YYYY') , 5  );
INSERT INTO EKSPEDYCJE  VALUES (seq_id_ekspedycji.nextval , 'Wyprawa' , 'Transport ludzi pomiedzy dwoma bazami', TO_DATE('07-07-2021','DD-MM-YYYY') , TO_DATE('03-11-2021','DD-MM-YYYY') , 4  );
INSERT INTO EKSPEDYCJE  VALUES (seq_id_ekspedycji.nextval , 'Próbki gleby' , 'Wyprawa w celu poboru próbek gleby', TO_DATE('07-08-2021','DD-MM-YYYY') , TO_DATE('13-08-2021','DD-MM-YYYY') , 4  );
SELECT * FROM EKSPEDYCJE;
--Tabela Narzedzia
INSERT INTO NARZEDZIA VALUES (seq_id_narzedzia.nextval , 'Nozyczki' , 4);
INSERT INTO NARZEDZIA VALUES (seq_id_narzedzia.nextval , 'Noz' , 4);
INSERT INTO NARZEDZIA VALUES (seq_id_narzedzia.nextval , 'Widelec' , 4);
INSERT INTO NARZEDZIA VALUES (seq_id_narzedzia.nextval , 'Lyzka' , 4);
INSERT INTO NARZEDZIA VALUES (seq_id_narzedzia.nextval , 'Maszynka_do_golenia' , 4);
INSERT INTO NARZEDZIA VALUES (seq_id_narzedzia.nextval , 'Sekator' , 5);
INSERT INTO NARZEDZIA VALUES (seq_id_narzedzia.nextval , 'Siekiera' , 5);
INSERT INTO NARZEDZIA VALUES (seq_id_narzedzia.nextval , 'Grabie' , 5);
INSERT INTO NARZEDZIA VALUES (seq_id_narzedzia.nextval , 'Lopata' , 5);
INSERT INTO NARZEDZIA VALUES (seq_id_narzedzia.nextval , 'Motyka' , 5);
INSERT INTO NARZEDZIA VALUES (seq_id_narzedzia.nextval , 'palnik' , 6);
INSERT INTO NARZEDZIA VALUES (seq_id_narzedzia.nextval , 'Motyka' , 5);
SELECT * FROM NARZEDZIA;
-- Tabela WSPOLZEDNE
INSERT INTO WSPOLZEDNE VALUES (seq_id_wspolzedne.nextval, 1, to_timestamp('03-07-2019 21:24:00', 'dd-mm-yyyy hh24:mi:ss') , 50.00000001 , -50.00000001);
INSERT INTO WSPOLZEDNE VALUES (seq_id_wspolzedne.nextval, 1, to_timestamp('03-08-2019 21:24:00', 'dd-mm-yyyy hh24:mi:ss') , 50.00100001 , -50.00100001);
INSERT INTO WSPOLZEDNE VALUES (seq_id_wspolzedne.nextval, 1, to_timestamp('03-09-2019 21:24:00', 'dd-mm-yyyy hh24:mi:ss') , 50.00200001 , -50.00200001);
INSERT INTO WSPOLZEDNE VALUES (seq_id_wspolzedne.nextval, 1, to_timestamp('03-10-2019 21:24:00', 'dd-mm-yyyy hh24:mi:ss') , 50.00300001 , -50.00300001);
INSERT INTO WSPOLZEDNE VALUES (seq_id_wspolzedne.nextval, 1, to_timestamp('03-11-2019 21:24:00', 'dd-mm-yyyy hh24:mi:ss') , 50.00400001 , -50.00400001);
INSERT INTO WSPOLZEDNE VALUES (seq_id_wspolzedne.nextval, 2, to_timestamp('21-08-2014 21:24:00', 'dd-mm-yyyy hh24:mi:ss') , 50.00000002 , -50.00000002);
INSERT INTO WSPOLZEDNE VALUES (seq_id_wspolzedne.nextval, 2, to_timestamp('21-09-2014 21:24:00', 'dd-mm-yyyy hh24:mi:ss') , 50.00100002 , -50.00100002);
INSERT INTO WSPOLZEDNE VALUES (seq_id_wspolzedne.nextval, 2, to_timestamp('21-10-2014 21:24:00', 'dd-mm-yyyy hh24:mi:ss') , 50.00200002 , -50.00200002);
INSERT INTO WSPOLZEDNE VALUES (seq_id_wspolzedne.nextval, 2, to_timestamp('21-11-2014 21:24:00', 'dd-mm-yyyy hh24:mi:ss') , 50.00300002 , -50.00300002);
INSERT INTO WSPOLZEDNE VALUES (seq_id_wspolzedne.nextval, 2, to_timestamp('21-12-2014 21:24:00', 'dd-mm-yyyy hh24:mi:ss') , 50.00400002 , -50.00400002);
INSERT INTO WSPOLZEDNE VALUES (seq_id_wspolzedne.nextval, 3, to_timestamp('21-12-1971 21:24:00', 'dd-mm-yyyy hh24:mi:ss') , 50.00000003 , -50.00000003);
INSERT INTO WSPOLZEDNE VALUES (seq_id_wspolzedne.nextval, 3, to_timestamp('21-01-1972 21:24:00', 'dd-mm-yyyy hh24:mi:ss') , 50.00100003 , -50.00100003);
INSERT INTO WSPOLZEDNE VALUES (seq_id_wspolzedne.nextval, 3, to_timestamp('21-02-1972 21:24:00', 'dd-mm-yyyy hh24:mi:ss') , 50.00200003 , -50.00200003);
INSERT INTO WSPOLZEDNE VALUES (seq_id_wspolzedne.nextval, 3, to_timestamp('21-03-1972 21:24:00', 'dd-mm-yyyy hh24:mi:ss') , 50.00300003 , -50.00300003);
INSERT INTO WSPOLZEDNE VALUES (seq_id_wspolzedne.nextval, 3, to_timestamp('21-04-1972 21:24:00', 'dd-mm-yyyy hh24:mi:ss') , 50.00400003 , -50.00400003);
INSERT INTO WSPOLZEDNE VALUES (seq_id_wspolzedne.nextval, 4, to_timestamp('08-07-2021 21:24:00', 'dd-mm-yyyy hh24:mi:ss') , 50.00000004 , -50.00000004);
INSERT INTO WSPOLZEDNE VALUES (seq_id_wspolzedne.nextval, 4, to_timestamp('09-07-2021 21:24:00', 'dd-mm-yyyy hh24:mi:ss') , 50.00100004 , -50.00100004);
INSERT INTO WSPOLZEDNE VALUES (seq_id_wspolzedne.nextval, 4, to_timestamp('10-07-2021 21:24:00', 'dd-mm-yyyy hh24:mi:ss') , 50.00200004 , -50.00200004);
INSERT INTO WSPOLZEDNE VALUES (seq_id_wspolzedne.nextval, 4, to_timestamp('11-07-2021 21:24:00', 'dd-mm-yyyy hh24:mi:ss') , 50.00300004 , -50.00300004);
INSERT INTO WSPOLZEDNE VALUES (seq_id_wspolzedne.nextval, 4, to_timestamp('12-07-2021 21:24:00', 'dd-mm-yyyy hh24:mi:ss') , 50.00400004 , -50.00400004);
INSERT INTO WSPOLZEDNE VALUES (seq_id_wspolzedne.nextval, 5, to_timestamp('07-08-2021 21:24:00', 'dd-mm-yyyy hh24:mi:ss') , 50.00000005 , -50.00000005);
INSERT INTO WSPOLZEDNE VALUES (seq_id_wspolzedne.nextval, 5, to_timestamp('07-08-2021 22:24:00', 'dd-mm-yyyy hh24:mi:ss') , 50.00100005 , -50.00100005);
INSERT INTO WSPOLZEDNE VALUES (seq_id_wspolzedne.nextval, 5, to_timestamp('07-08-2021 23:24:00', 'dd-mm-yyyy hh24:mi:ss') , 50.00200005 , -50.00200005);
INSERT INTO WSPOLZEDNE VALUES (seq_id_wspolzedne.nextval, 5, to_timestamp('08-08-2021 00:24:00', 'dd-mm-yyyy hh24:mi:ss') , 50.00300005 , -50.00300005);
INSERT INTO WSPOLZEDNE VALUES (seq_id_wspolzedne.nextval, 5, to_timestamp('08-08-2021 01:24:00', 'dd-mm-yyyy hh24:mi:ss') , 50.00400005 , -50.00400005);
SELECT * FROM WSPOLZEDNE;
-- Tabela WYPOSAZENIE
INSERT INTO WYPOSAZENIE VALUES (seq_id_wyposazenie.nextval, 1, 1);
INSERT INTO WYPOSAZENIE VALUES (seq_id_wyposazenie.nextval, 1, 8);
INSERT INTO WYPOSAZENIE VALUES (seq_id_wyposazenie.nextval, 1, 12);
INSERT INTO WYPOSAZENIE VALUES (seq_id_wyposazenie.nextval, 2, 2);
INSERT INTO WYPOSAZENIE VALUES (seq_id_wyposazenie.nextval, 2, 3);
INSERT INTO WYPOSAZENIE VALUES (seq_id_wyposazenie.nextval, 2, 11);
INSERT INTO WYPOSAZENIE VALUES (seq_id_wyposazenie.nextval, 3, 4);
INSERT INTO WYPOSAZENIE VALUES (seq_id_wyposazenie.nextval, 3, 5);
INSERT INTO WYPOSAZENIE VALUES (seq_id_wyposazenie.nextval, 3, 6);
INSERT INTO WYPOSAZENIE VALUES (seq_id_wyposazenie.nextval, 4, 8);
INSERT INTO WYPOSAZENIE VALUES (seq_id_wyposazenie.nextval, 4, 5);
INSERT INTO WYPOSAZENIE VALUES (seq_id_wyposazenie.nextval, 4, 10);
INSERT INTO WYPOSAZENIE VALUES (seq_id_wyposazenie.nextval, 5, 10);
INSERT INTO WYPOSAZENIE VALUES (seq_id_wyposazenie.nextval, 5, 2);
INSERT INTO WYPOSAZENIE VALUES (seq_id_wyposazenie.nextval, 5, 8);
SELECT * FROM WYPOSAZENIE;


/*
DROP TABLE POMIESZCZENIA CASCADE CONSTRAINT;
DROP TABLE SCHOWKI CASCADE CONSTRAINT;
DROP TABLE POJEMNIKI CASCADE CONSTRAINT;
DROP TABLE TYPY_AKUMULATOROW CASCADE CONSTRAINT;
DROP TABLE AKUMULATORY CASCADE CONSTRAINT;
DROP TABLE POJAZDY CASCADE CONSTRAINT;
DROP TABLE CZESCI CASCADE CONSTRAINT;
DROP TABLE EKSPEDYCJE CASCADE CONSTRAINT;
DROP TABLE WSPOLZEDNE CASCADE CONSTRAINT;
DROP TABLE NARZEDZIA CASCADE CONSTRAINT;
DROP TABLE WYPOSAZENIE CASCADE CONSTRAINT;
DROP SEQUENCE seq_id_pomieszczenia;
DROP SEQUENCE seq_id_schowka;
DROP SEQUENCE seq_id_pojemnika;
DROP SEQUENCE seq_id_typu_akumulatora;
DROP SEQUENCE seq_id_akumulatora;
DROP SEQUENCE seq_id_pojazdu;
DROP SEQUENCE seq_id_czesci;
DROP SEQUENCE seq_id_ekspedycji;
DROP SEQUENCE seq_id_wspolzedne;
DROP SEQUENCE seq_id_narzedzia;
DROP SEQUENCE seq_id_wyposazenie;
*/

--COMMIT;
--ROLLBACK;

---------------------------------------------------------------

---Autorzy Milosz Latanik, Jakub Kurczynski
CREATE OR REPLACE PACKAGE PACKAGE1 AS 
    FUNCTION food_rations (eks_id NUMBER)
     RETURN NUMBER;
    PROCEDURE ladowanie;
    PROCEDURE kod_czesci;
    
END PACKAGE1;
/


CREATE OR REPLACE PACKAGE BODY PACKAGE1 
AS
---Funkcja FOOD RATIONS dziala w ten sposób ze oblicza ile racji zywnosciowych
---bylo potrzebnych na dana ekspedycje przy zalozeniu ze na jeden dzien potrzeba 3 racji
---KOMENDA DO WYOWLANIA SELECT PACKAGE1.food_rations(6)FROM DUAL;

    FUNCTION food_rations(eks_id NUMBER) 
    RETURN NUMBER AS
    food NUMBER;
    BEGIN
        SELECT DATA_ZAKONCZENIA-DATA_ROZPOCZECIA 
        INTO food FROM EKSPEDYCJE WHERE id_ekspedycji=eks_id;
    RETURN food*3;
    END food_rations;
    
---Procedura ladowanie wyszukuje akumulatora ktory jest rozladowany zmienia jego stan naladowania na 100 
---oraz liczbe cyklow ladowania na o jeden wieksza uzywamy w chwilii gdy ktoś w bazie naladuje rozladowany akumulator
---KOMENDA DO WYWOLANIA   EXECUTE PACKAGE1.ladowanie()
    PROCEDURE ladowanie is
    BEGIN
        UPDATE AKUMULATORY SET STAN=100, CYKLE_LADOWANIA=CYKLE_LADOWANIA+1 
        WHERE STAN= 0;
    END ladowanie;
---Procedura kod_czesci nadaje kod dla kazdej czesci. Kod sklada sie z pierwszych 4 znakó nazwy oraz 4 losowych liczb
---KOMENDA DO WYWOLANIA  EXECUTE PACKAGE1.kod_czesci()
    PROCEDURE kod_czesci is 
     n pls_integer;
     p NUMBER;
    BEGIN
        SELECT COUNT (*) INTO p FROM CZESCI;
        FOR i in 1..p LOOP
          SELECT dbms_random.value(1000,9999) num INTO n from DUAL;
        UPDATE CZESCI SET KOD=CONCAT(SUBSTR(NAZWA,0,4), n ) WHERE ID_CZESCI= i;
        END LOOP;
       
    END kod_czesci;
END PACKAGE1;
/

-----------

--Miłosz �?atanik, Jakub Kurczyński

--TRIGGER 1, BATTERY_CHECK sprawdza czy w pojeździe montowana jest bateria odpowiedniego typu
CREATE OR REPLACE TRIGGER BATTERY_CHECK
    BEFORE INSERT OR UPDATE ON POJAZDY
    FOR EACH ROW
DECLARE
    v_type NUMBER(3);
BEGIN
    select typ_akumulatora into v_type from akumulatory where id_akumulatora=(:new.id_akumulatora);
    IF (v_type !=  (:new.typ_akumulatora) ) THEN
        raise_application_error(-20002,'Błędny typ akumulatora dla pojazdu '||(:new.id_pojazdu)||', porawny typ akumulatora to '||(:new.typ_akumulatora));
    END IF;
END BATTERY_CHECK;
--update pojazdy set id_akumulatora = 5 where id_pojazdu = 1;

--TRIGGER 2, UPDATE_BATTERY_ON_REPLACEMENT usuwa lokalizacje baterii kiedy jest wsadzana do pojazdu
--oraz ustawia lokalizacje wyjmowanej baterii na pojemnik NR 10
CREATE OR REPLACE TRIGGER UPDATE_BATTERY_ON_PUT_IN_VECHICLE
    AFTER INSERT OR UPDATE ON POJAZDY
    FOR EACH ROW
BEGIN
    IF ( (:OLD.ID_AKUMULATORA) !=  (:NEW.ID_AKUMULATORA)) THEN
        UPDATE AKUMULATORY SET ID_POJEMNIKA=10 WHERE ID_AKUMULATORA=(:OLD.ID_AKUMULATORA);
        UPDATE AKUMULATORY SET ID_POJEMNIKA=NULL WHERE ID_AKUMULATORA=(:NEW.ID_AKUMULATORA);
    END IF;
END UPDATE_BATTERY_ON_REPLACEMENT;
--SELECT * FROM AKUMULATORY;
--update pojazdy set id_akumulatora = 1 where id_pojazdu = 5;
--SELECT * FROM AKUMULATORY;

--TRIGGER 3, MODIFY_AKUMULATORY_SZCZEGOLOWO pozwala na modyfikowanie danych w widoku
CREATE OR REPLACE VIEW AKUMULATORY_SZCZEGOLOWO AS
SELECT * FROM AKUMULATORY LEFT JOIN TYPY_AKUMULATOROW ON AKUMULATORY.TYP_AKUMULATORA = TYPY_AKUMULATOROW.ID_TYPU_AKUMULATORA;

CREATE OR REPLACE TRIGGER MODIFY_AKUMULATORY_SZCZEGOLOWO
    INSTEAD OF INSERT ON AKUMULATORY_SZCZEGOLOWO
    FOR EACH ROW
BEGIN
    INSERT INTO AKUMULATORY VALUES(seq_id_akumulatora.nextval, :NEW.typ_akumulatora, :NEW.waga_kg, :NEW.pojemnosc_ah, :NEW.cykle_ladowania, :NEW.stan, :NEW.id_pojemnika);
END MODIFY_AKUMULATORY_SZCZEGOLOWO;

--update AKUMULATORY_SZCZEGOLOWO set stan=100;

-------------------------------------------------------


--Miłosz �?atanik, Jakub Kurczyński
--DROP TABLE TAB_KWATERMISTRZ
--Obiekt kwatermistrz
CREATE OR REPLACE TYPE T_KWATERMISTRZ AS OBJECT
(
  id_czlowieka number(4),
  imie varchar2(100),
  nazwisko varchar2(100),
  MEMBER FUNCTION PRZEDSTAW_SIE RETURN VARCHAR2
);
--FUNKCJA Wyswietlajaca dane Kwatermistrza
CREATE OR REPLACE TYPE BODY T_KWATERMISTRZ AS 
    MEMBER FUNCTION PRZEDSTAW_SIE RETURN VARCHAR2 AS
        f_result VARCHAR2(100);
    BEGIN
        f_result := ' Imie: ' || imie || ', Nazwisko ' || nazwisko || ' Moje ID: ' || id_czlowieka;
        RETURN f_result;
    END;
END;

CREATE TABLE kwatermistrze OF T_KWATERMISTRZ;
INSERT INTO kwatermistrze VALUES (T_KWATERMISTRZ(1, 'Jan','Nowak'));
SELECT * FROM kwatermistrze;


--Objekt robot jest to maszyna produkujca plastikowe elementy np czesci. Tworzy ona "nowe czesci"(dodaje je do tabeli "czesci")


CREATE OR REPLACE TYPE T_robot AS OBJECT
(
    id_robota number(4),
    nazwa varchar2(100),
    MEMBER PROCEDURE stworz_czesc (
        p_KOD VARCHAR2,
        p_NAZWA VARCHAR2,
        p_ID_POJAZDU NUMBER,
        p_ID_POJEMNIKA NUMBER)
    );
    
CREATE OR REPLACE TYPE BODY T_robot AS 
MEMBER PROCEDURE stworz_czesc(
    p_KOD VARCHAR2,
    p_NAZWA VARCHAR2,
    p_ID_POJAZDU NUMBER,
    p_ID_POJEMNIKA NUMBER)
IS
BEGIN
    INSERT INTO CZESCI VALUES (
        seq_id_czesci.nextval,
        p_KOD,
        p_NAZWA,
        p_ID_POJAZDU,
        p_ID_POJEMNIKA);
    COMMIT;
END;
END;

--

CREATE OR REPLACE VIEW xml_lista_pojazdow (POJAZDY) AS
    SELECT XMLElement( NAME "POJAZDY", XMLForest( ID_POJAZDU , NAZWA , DATA_PRODUKCJI))
    FROM POJAZDY;


SELECT * FROM xml_lista_pojazdow;
SELECT eXTRACTVALUE(POJAZDY, '/POJAZDY/NAZWA') FROM xml_lista_pojazdow;
SELECT XMLElement (NAME "Pojazd", XMLAttributes( pojazd.ID_POJAZDU AS "ID"), pojazd.NAZWA) AS "NAZWA POJAZDU" FROM POJAZDY pojazd;

SELECT * FROM NARZEDZIA;

CREATE OR REPLACE VIEW narzedzie_pojemnik_xml_view (NAREDZIA) AS 
    SELECT XMLElement(NAME "pojemnik", XMLAttributes( NAZWA_POJEMNIKA AS "Nazwa Poj"), XMLAgg(XMLElement(NAME "przedmiot" , NAZWA) ORDER BY NAZWA)) AS "result" FROM NARZEDZIA JOIN POJEMNIKI USING(ID_POJEMNIKA) GROUP BY NAZWA_POJEMNIKA;
    
SELECT * FROM narzedzie_pojemnik_xml_view; 