-- Create a scalar-valued function that returns the factorial of a number you gave it.

CREATE FUNCTION [dbo].[Factorial] (@n int)
RETURNS int
AS
BEGIN
    DECLARE @result int
    IF @n = 0
        SET @result = 1
    ELSE
        SET @result = @n * dbo.Factorial(@n - 1)
    RETURN @result
END

-- Call the function
SELECT dbo.Factorial(5)

-- Output: 120