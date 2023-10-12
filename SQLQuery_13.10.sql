use [Dating]
CREATE TABLE WordCount (Word VARCHAR(255), Count INT);

-- ќбъ€вл€ю курсор дл€ выборки данных из столбца mess
DECLARE @message VARCHAR(255);

DECLARE mess_cursor CURSOR FOR
SELECT mess
FROM messages;


DECLARE @word VARCHAR(255);--сохран€ем сюда слова
DECLARE @word_count INT;--сюда ихнее кол-во

OPEN mess_cursor;

FETCH NEXT FROM mess_cursor INTO @message;-- „итаю данные из курсора

SET @word = '';
SET @word_count = 0;

-- ѕока есть записи в курсоре
WHILE @@FETCH_STATUS = 0
BEGIN
    WHILE LEN(@message) > 0
    BEGIN
        SET @word = LEFT(@message, CHARINDEX(' ', @message + ' ') - 1);
        SET @message = SUBSTRING(@message, LEN(@word) + 2, LEN(@message));
        
        IF LEN(@word) > 0
        BEGIN
            
            IF EXISTS (SELECT * FROM WordCount WHERE Word = @word)--проверка на наличие такого слова в таблице
            BEGIN
                UPDATE WordCount
                SET Count = Count + 1
                WHERE Word = @word;
            END
            ELSE
            BEGIN
                INSERT INTO WordCount (Word, Count)-- ¬ставл€ем новое слово в таблицу WordCount
                VALUES (@word, 1);
            END
        END
    END
    FETCH NEXT FROM mess_cursor INTO @message;
END
CLOSE mess_cursor;
DEALLOCATE mess_cursor;

SELECT * FROM WordCount; -- показ

DROP TABLE WordCount;-- удал€ю таблицу
