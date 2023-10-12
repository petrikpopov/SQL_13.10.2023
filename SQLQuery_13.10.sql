use [Dating]
CREATE TABLE WordCount (Word VARCHAR(255), Count INT);

-- �������� ������ ��� ������� ������ �� ������� mess
DECLARE @message VARCHAR(255);

DECLARE mess_cursor CURSOR FOR
SELECT mess
FROM messages;


DECLARE @word VARCHAR(255);--��������� ���� �����
DECLARE @word_count INT;--���� ����� ���-��

OPEN mess_cursor;

FETCH NEXT FROM mess_cursor INTO @message;-- ����� ������ �� �������

SET @word = '';
SET @word_count = 0;

-- ���� ���� ������ � �������
WHILE @@FETCH_STATUS = 0
BEGIN
    WHILE LEN(@message) > 0
    BEGIN
        SET @word = LEFT(@message, CHARINDEX(' ', @message + ' ') - 1);
        SET @message = SUBSTRING(@message, LEN(@word) + 2, LEN(@message));
        
        IF LEN(@word) > 0
        BEGIN
            
            IF EXISTS (SELECT * FROM WordCount WHERE Word = @word)--�������� �� ������� ������ ����� � �������
            BEGIN
                UPDATE WordCount
                SET Count = Count + 1
                WHERE Word = @word;
            END
            ELSE
            BEGIN
                INSERT INTO WordCount (Word, Count)-- ��������� ����� ����� � ������� WordCount
                VALUES (@word, 1);
            END
        END
    END
    FETCH NEXT FROM mess_cursor INTO @message;
END
CLOSE mess_cursor;
DEALLOCATE mess_cursor;

SELECT * FROM WordCount; -- �����

DROP TABLE WordCount;-- ������ �������
