CREATE FUNCTION [dbo].[CRC_CCITT_0xFFFF] (
    @input VARBINARY(MAX)
)
RETURNS NVARCHAR(4)
AS
BEGIN
    DECLARE @crc INT = 0xFFFF
    DECLARE @poly INT = 0x1021
    DECLARE @i INT = 1
    DECLARE @j INT
    DECLARE @byte INT
    DECLARE @bit INT

    WHILE @i <= DATALENGTH(@input)
    BEGIN
        SET @byte = CONVERT(INT, SUBSTRING(@input, @i, 1))
        SET @crc = @crc ^ (@byte * 256)
        
        SET @j = 0
        WHILE @j < 8
        BEGIN
            IF (@crc & 0x8000) <> 0
                SET @crc = ((@crc * 2) & 0xFFFF) ^ @poly
            ELSE
                SET @crc = (@crc * 2) & 0xFFFF
            
            SET @j = @j + 1
        END
        
        SET @i = @i + 1
    END

    RETURN UPPER(CONVERT(NVARCHAR(4), SUBSTRING(CONVERT(VARBINARY(2), @crc), 1, 2), 2))
END
