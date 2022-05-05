USE Hospital;
GO

/*-------------------------------------------------------------------------------------------------------------------------------------------------
  05 05 2022
-------------------------------------------------------------------------------------------------------------------------------------------------*/

/*27. ������� �������, ���, �������� ������, ������� ������� ����� 20 ������� � ���� ����.
��������� ����������� �� ������� � ������� �������� �������������������.*/
WITH receptionsDay AS (
	SELECT r.serviceNumber_id, COUNT(*) receptionDay
	FROM receptions r
	GROUP BY r.serviceNumber_id, r.date
)
SELECT d.surname, d.name, ISNULL(d.patronymic,'') 'patronymic'
FROM doctors d
JOIN receptionsDay r
	ON d.id = r.serviceNumber_id
WHERE r.receptionDay > 20
ORDER BY 1 DESC;

/*31. ������� ���������� ��� ���� ������, � ���� ���� ������ � ����� �������, �� ���������� �������� ���������.*/
WITH numberOfPatientsToday AS (
	SELECT r.serviceNumber_id, COUNT(*) countPatients
	FROM receptions r
	WHERE DAY(GETDATE()) = DAY(r.date) AND MONTH(GETDATE()) = MONTH(r.date) AND YEAR(GETDATE()) = YEAR(r.date)
	GROUP BY r.serviceNumber_id	
)
SELECT d.*, ISNULL(CAST(r.countPatients AS nvarchar(50)),'') '���������� ��������� �������'
FROM doctors d
LEFT JOIN numberOfPatientsToday r
	ON d.id = r.serviceNumber_id;

/*32. ������� ��� ���������� � �����, ��������� ������ ����� ��������� �������.*/
WITH mostPatientsToday AS (
	SELECT TOP 1 COUNT(*) countPatients, r.serviceNumber_id
	FROM receptions r
	WHERE DAY(GETDATE()) = DAY(r.date) AND MONTH(GETDATE()) = MONTH(r.date) AND YEAR(GETDATE()) = YEAR(r.date)
	GROUP BY r.serviceNumber_id
)
SELECT d.*
FROM doctors d
JOIN mostPatientsToday r
	ON d.id = r.serviceNumber_id;

/*33. ������� ��� ���������, ������� �������� ���� ������.*/
WITH visitedAllDoctors AS (
	SELECT r.patient_id
	FROM receptions r
	GROUP BY r.patient_id
	HAVING COUNT(r.serviceNumber_id) = (
		SELECT COUNT(*)
		FROM doctors
	)
)
SELECT p.surname + ' ' + p.name + ISNULL(' ' + p.patronymic,'') '��� ���������, ������� �������� ���� ������'
FROM patients p
JOIN visitedAllDoctors r
	ON p.id = r.patient_id;

/*36. ��� ������� ����������� ���� ������� ���������� ���������, ��������� � ���� ����.*/
SELECT YEAR(birthday) leapYear, COUNT(*) countPatients
FROM patients
WHERE ISDATE(CAST(birthday AS char(4))+ '0229') = 1
GROUP BY YEAR(birthday);

SELECT YEAR(birthday) ���, COUNT(*) ����������
FROM patients
WHERE YEAR(birthday) % 4 = 0 AND YEAR(birthday) % 100 != 0 OR YEAR(birthday) % 400 = 0
GROUP BY YEAR(birthday);

/*42. ������� ��� � ���� �������� ���� ����� ������� ������.*/
SELECT TOP 3 d.surname + ' ' + d.name + ISNULL(' ' + d.patronymic,'') '��� ���� ����� ������� ������', d.birthday
FROM doctors d
ORDER BY d.birthday DESC;