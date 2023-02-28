CREATE OR REPLACE PROCEDURE mlode_osoby AS
BEGIN
    DECLARE
        imie_ucz varchar2(255);
        nazwisko_ucz varchar2(255);
        data_urodzenia_ucz date;
        CURSOR uczenie_cursor IS
        SELECT IMIE_UCZEN, NAZWISKO_UCZEN, DATA_URODZENIA_UCZEN
        FROM UCZNIOWIE
        WHERE DATA_URODZENIA_UCZEN > '2005-01-01';
    BEGIN
        FOR uczenie_rec IN uczenie_cursor LOOP
            dbms_output.put_line(uczenie_rec.IMIE_UCZEN || ' ' || uczenie_rec.NAZWISKO_UCZEN || ' urodzony/a ' || uczenie_rec.DATA_URODZENIA_UCZEN);
        END LOOP;
    END;
END;


CREATE OR REPLACE PROCEDURE najlepsze_oceny IS
  CURSOR c1 IS
    SELECT uczen_klasa.id_uczen_klasa, uczniowie.imie_uczen, uczniowie.nazwisko_uczen, swiadectwo.srednia
    FROM Uczen_klasa
    JOIN swiadectwo ON uczen_klasa.id_uczen_klasa = swiadectwo.id_uczen_klasa
    JOIN uczniowie on uczen_klasa.id_uczen_klasa = uczniowie.id_uczen
    WHERE swiadectwo.srednia >= 3.5;
BEGIN
  FOR uczen IN c1 LOOP
    DBMS_OUTPUT.PUT_LINE(uczen.imie_uczen || ' ' || uczen.nazwisko_uczen || ' uzyskał średnią ' || uczen.srednia);
  END LOOP;
END najlepsze_oceny;
