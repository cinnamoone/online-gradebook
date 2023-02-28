--
--CREATE or replace VIEW uczen_i_rodzice AS
--SELECT UCZNIOWIE.IMIE_UCZEN, UCZNIOWIE.NAZWISKO_UCZEN, RODZICE.IMIE_RODZIC, RODZICE.NAZWISKO_RODZIC
--FROM UCZNIOWIE
--JOIN UCZEN_RODZIC ON UCZNIOWIE.ID_UCZEN = UCZEN_RODZIC.ID_UCZEN
--JOIN RODZICE ON UCZEN_RODZIC.ID_RODZIC = RODZICE.ID_RODZIC
--order by NAZWISKO_UCZEN;
----SELECT *
----FROM uczen_i_rodzice;
--
--CREATE or replace VIEW rodzic_i_dzieci AS
--SELECT RODZICE.IMIE_RODZIC, RODZICE.NAZWISKO_RODZIC, UCZNIOWIE.IMIE_UCZEN, UCZNIOWIE.NAZWISKO_UCZEN, UCZNIOWIE.PESEL_UCZEN
--FROM RODZICE
--JOIN UCZEN_RODZIC ON RODZICE.ID_RODZIC = UCZEN_RODZIC.ID_RODZIC
--JOIN UCZNIOWIE ON UCZEN_RODZIC.ID_UCZEN = UCZNIOWIE.ID_UCZEN
--order by nazwisko_rodzic;
--
--SELECT *
--FROM rodzic_i_dzieci;
--


--
--SET Serveroutput on
--DECLARE
--CURSOR uczen_ocena IS SELECT u.imie_uczen, u.nazwisko_uczen, o.wartosc_oceny, o.data_wpisania, p.nazwa_przedmiot FROM uczniowie u
--JOIN oceny o on o.id_uczen= u.id_uczen
--JOIN przedmioty p on o.id_przedmiot = p.id_przedmiot
--;
--BEGIN
--FOR temp IN uczen_ocena LOOP
--DBMS_OUTPUT.PUT_LINE(
--INITCAP(temp.imie_uczen) || ' ' ||
--INITCAP(temp.nazwisko_uczen) || ', ocena: ' ||
--INITCAP(temp.wartosc_oceny) || ', data wpisania: ' ||
--UPPER(to_char(temp.data_wpisania, 'DD Month')) || ' ' ||
--LOWER(temp.nazwa_przedmiot));
--END LOOP;
--END;

--CREATE OR REPLACE FUNCTION ilePrzedmiotowNauczyciel
--(v_nauczyciel IN VARCHAR2) RETURN NUMBER IS
--v_licznik NUMBER;
--BEGIN
--v_licznik := 0;
--FOR i IN(SELECT przedmioty.id_przedmiot FROM nauczyciele, przedmioty, naucz_przedm_klasa 
--WHERE naucz_przedm_klasa.id_przedmiot = przedmioty.id_przedmiot 
--AND naucz_przedm_klasa.id_nauczyciel = nauczyciele.id_nauczyciel
--and
--nauczyciele.id_nauczyciel = v_nauczyciel) LOOP
--v_licznik := v_licznik + 1;
--END LOOP;
--RETURN v_licznik;
--END ilePrzedmiotowNauczyciel;
----run
--/
--SET Serveroutput on
--DECLARE
--v_nauczyciel VARCHAR2(200);
--v_return NUMBER;
--BEGIN
--v_nauczyciel := &id_nauczyciela;
--v_return := ilePrzedmiotowNauczyciel(v_nauczyciel => v_nauczyciel);
--IF v_nauczyciel > 20 THEN
--      RAISE_APPLICATION_ERROR(-20001, 'Blad! Nie ma nauczyciela o takim id!');
--END IF;
--DBMS_OUTPUT.PUT_LINE('Ten nauczyciel prowadzi tyle przedmiotów: ' || v_Return);
--END;
--
--INSERT INTO OCENY (ID_OCENA, ID_PRZEDMIOT, ID_RODZAJ_OCENY, wartosc_oceny, ID_NAUCZYCIEL, ID_UCZEN, WYMAGANA, DATA_OCENY, DATA_WPISANIA, DATA_MODYFIKACJI) VALUES (11, 5, 10, 4,10, 10, 'tak', '2022-05-21', '2022-05-21', '2022-05-21');
--
--
--drop table oceny_log;
--CREATE TABLE OCENY_log(
--    ID_OCENA                    NUMBER(10) NOT NULL CONSTRAINT PK_ID_OCENA_log PRIMARY KEY,
--    ID_PRZEDMIOT                NUMBER(10) CONSTRAINT FK_ID_PRZEDMIOT_OCENY_log REFERENCES PRZEDMIOTY(ID_PRZEDMIOT),
--    ID_RODZAJ_OCENY             NUMBER(10) CONSTRAINT FK_ID_RODZAJ_OCENY_log REFERENCES RODZAJ_OCENY(ID_RODZAJ_OCENY),
--    wartosc_oceny               float(10),
--    ID_NAUCZYCIEL               NUMBER(10) CONSTRAINT FK_ID_NAUCZYCIEL_OCENY_log REFERENCES NAUCZYCIELE(ID_NAUCZYCIEL),
--    ID_UCZEN                    NUMBER(10) CONSTRAINT FK_ID_UCZEN_OCENY_log REFERENCES UCZNIOWIE(ID_UCZEN),
--    WYMAGANA                    VARCHAR2(3),
--    DATA_OCENY                  DATE,
--    DATA_WPISANIA               DATE,
--    DATA_MODYFIKACJI            TIMESTAMP,
--    log_operation               VARCHAR2(20)
--);


--CREATE OR REPLACE TRIGGER Log_oceny_insert
--AFTER INSERT ON oceny
--FOR EACH ROW
--BEGIN
--INSERT INTO oceny_log (
--id_ocena,
--id_przedmiot,
--ID_rodzaj_oceny,
--wartosc_oceny,
--id_nauczyciel,
--id_uczen,
--wymagana,
--data_oceny,
--data_wpisania,
--data_modyfikacji,
--log_operation
--) VALUES (
--:NEW.id_ocena,
--:NEW.id_przedmiot,
--:NEW.ID_rodzaj_oceny,
--:NEW.wartosc_oceny,
--:NEW.id_nauczyciel,
--:NEW.id_uczen,
--:NEW.wymagana,
--:NEW.data_oceny,
--:NEW.data_wpisania,
--:NEW.data_modyfikacji,
--'nowa ocena insert'
--);
--END;


CREATE OR REPLACE TRIGGER log_oceny_UPDATE
AFTER UPDATE ON oceny
FOR EACH ROW 
BEGIN
INSERT INTO oceny_log (
id_ocena,
id_przedmiot,
ID_rodzaj_oceny,
wartosc_oceny,
id_nauczyciel,
id_uczen,
wymagana,
data_oceny,
data_wpisania,
data_modyfikacji,
log_operation
) VALUES (
:NEW.id_ocena,
:NEW.id_przedmiot,
:NEW.ID_rodzaj_oceny,
:NEW.wartosc_oceny,
:NEW.id_nauczyciel,
:NEW.id_uczen,
:NEW.wymagana,
:NEW.data_oceny,
:NEW.data_wpisania,
:NEW.data_modyfikacji,
'UPDATE oceny');
END;


CREATE OR REPLACE TRIGGER Log_ocena_DELETE
AFTER DELETE ON oceny
FOR EACH ROW
BEGIN
INSERT INTO oceny_log (
id_ocena,
id_przedmiot,
ID_rodzaj_oceny,
wartosc_oceny,
id_nauczyciel,
id_uczen,
wymagana,
data_oceny,
data_wpisania,
data_modyfikacji,
log_operation
) VALUES (
:NEW.id_ocena,
:NEW.id_przedmiot,
:NEW.ID_rodzaj_oceny,
:NEW.wartosc_oceny,
:NEW.id_nauczyciel,
:NEW.id_uczen,
:NEW.wymagana,
:NEW.data_oceny,
:NEW.data_wpisania,
:NEW.data_modyfikacji,
'DELETE'
);
END;