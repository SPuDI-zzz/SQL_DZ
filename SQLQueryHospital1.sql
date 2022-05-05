USE Hospital;
GO

/*-------------------------------------------------------------------------------------------------------------------------------------------------
  05 05 2022
-------------------------------------------------------------------------------------------------------------------------------------------------*/

/*27. Вывести фамилию, имя, отчество врачей, которые сделали более 20 приемов в один день.
Результат упорядочить по фамилии в порядке обратном лексикографическому.*/
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

/*31. Вывести информацию обо всех врачах, и если были приемы у врача сегодня, то количество принятых пациентов.*/
WITH numberOfPatientsToday AS (
	SELECT r.serviceNumber_id, COUNT(*) countPatients
	FROM receptions r
	WHERE DAY(GETDATE()) = DAY(r.date) AND MONTH(GETDATE()) = MONTH(r.date) AND YEAR(GETDATE()) = YEAR(r.date)
	GROUP BY r.serviceNumber_id	
)
SELECT d.*, ISNULL(CAST(r.countPatients AS nvarchar(50)),'') 'количество пациентов сегодня'
FROM doctors d
LEFT JOIN numberOfPatientsToday r
	ON d.id = r.serviceNumber_id;

/*32. Вывести всю информацию о враче, принявшим больше всего пациентов сегодня.*/
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

/*33. Выбрать ФИО пациентов, которые посетили всех врачей.*/
WITH visitedAllDoctors AS (
	SELECT r.patient_id
	FROM receptions r
	GROUP BY r.patient_id
	HAVING COUNT(r.serviceNumber_id) = (
		SELECT COUNT(*)
		FROM doctors
	)
)
SELECT p.surname + ' ' + p.name + ISNULL(' ' + p.patronymic,'') 'ФИО пациентов, которые посетили всех врачей'
FROM patients p
JOIN visitedAllDoctors r
	ON p.id = r.patient_id;

/*36. Для каждого високосного года вывести количество пациентов, рожденных в этом году.*/
SELECT YEAR(birthday) leapYear, COUNT(*) countPatients
FROM patients
WHERE ISDATE(CAST(birthday AS char(4))+ '0229') = 1
GROUP BY YEAR(birthday);

SELECT YEAR(birthday) Год, COUNT(*) Количество
FROM patients
WHERE YEAR(birthday) % 4 = 0 AND YEAR(birthday) % 100 != 0 OR YEAR(birthday) % 400 = 0
GROUP BY YEAR(birthday);

/*42. Вывести ФИО и дату рождения трех самых молодых врачей.*/
SELECT TOP 3 d.surname + ' ' + d.name + ISNULL(' ' + d.patronymic,'') 'ФИО трех самых молодых врачей', d.birthday
FROM doctors d
ORDER BY d.birthday DESC;