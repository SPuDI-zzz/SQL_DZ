USE University;
GO

/*3. Выбрать фамилию и инициалы студентов в одном столбце. Результат отсортировать по фамилии в порядке обратном лексикографическому.*/
SELECT surname + ' '+ LEFT(name,1) + '.' + ISNULL(' '+LEFT(patronymic, 1)+'.',' ') AS ФИО
FROM students
ORDER BY surname DESC;

/*7. Выбрать фамилии с инициалами тех студентов, у которых хотя бы одно из значений полей неопределено. Результата отсортировать по фамилии.*/
SELECT REPLACE(surname + ' '+ LEFT(name,1) + '. ' + ISNULL(LEFT(patronymic, 1)+'.',' '),'. .','.') AS ФИО
FROM students
WHERE name IS NULL OR surname IS NULL OR patronymic IS NULL
ORDER BY surname;

/*9. Выбрать названия факультетов, у которых нет декана.*/
SELECT name
FROM faculties
WHERE dean_id IS NULL;

/*13. Выбрать фамилию, имя, отчество преподавателей, у которых есть руководитель. Результат отсортировать по фамилии, имени, отчеству в порядке обратном лексикографическому.*/
SELECT surname, name, ISNULL(patronymic,'')
FROM teachers
WHERE head_of_teacher_id IS NOT NULL
ORDER BY surname, name, patronymic DESC;

/*18. Вывести фамилию, имя, отчество преподавателей в одном столбце результирующей таблицы. Напротив каждой фамилии вывести ‘Преподаватель’ в том же столбце.*/
SELECT surname + ' ' + name + ' ' + ISNULL(patronymic,'') AS FIO, 'Преподаватель' AS Teacher
FROM teachers

/*21. Выбрать фамилию и инициалы (в одном столбце) студентов, которые учатся с 1 по 10 группах. Пример строки в результирующей таблице: Иванов И. И. Результат отсортировать по фамилии в порядке обратном лексикографическому.*/
SELECT surname + ' '+ LEFT(name,1) + '.' + ISNULL(' '+LEFT(patronymic, 1)+'.',' ') AS ФИО
FROM students
WHERE [group] BETWEEN 1 AND 10
ORDER BY surname DESC;

/*22. Выбрать названия факультетов с id_факультета равному 2, 3, 5, 6, 7 или 10. Результат отсортировать в порядке обратном лексикографическому.*/
SELECT name
FROM faculties
WHERE id IN (2, 3, 5, 6, 7, 10)
ORDER BY name DESC;

/*23. Выбрать названия факультетов с id_факультета НЕ равному 2, 3, 5, 6, 7 или 10. Результат отсортировать в порядке обратном лексикографическому.*/
SELECT name
FROM faculties
WHERE id NOT IN (2, 3, 5, 6, 7, 10)
ORDER BY name DESC;

/*24. Выбрать все данные о студентах, округлив размер стипендии до сотых.*/
SELECT id, name, surname, ISNULL(patronymic,'') AS patronymic, birthday, course, [group], ISNULL(ROUND([grant],2),'') AS [grant], faculty_id
FROM students

/*25. Выбрать названия должностей, которые начинаются на букву П.*/
SELECT name
FROM posts
WHERE name LIKE 'П%';

/*26. Выбрать названия должностей, которые начинаются на букву П или А.*/
SELECT name
FROM posts
WHERE name LIKE 'П%' OR name LIKE 'А%';

/*27. Выбрать все данные о дисциплинах, в названии которых есть кавычки.*/
SELECT *
FROM disciplines
WHERE name LIKE '%@"%@"%' ESCAPE '@';

/*28. Выбрать все данные о студентах с двойной фамилией или без отчества.*/
SELECT id, name, surname, ISNULL(patronymic,'') AS patronymic, birthday, course, [group], ISNULL([grant],'') AS [grant], faculty_id
FROM students
WHERE surname LIKE '_%-_%' OR patronymic IS NULL

/*29. Выбрать номера студенческих билетов и ФИО студентов email, которых содержит mail, gmail, _, или +.*/
SELECT id, surname + ' '+ LEFT(name,1) + '.' + ISNULL(' '+LEFT(patronymic, 1)+'.',' ') AS ФИО
FROM students
WHERE mail LIKE '%@__%' ESCAPE '@' OR mail LIKE '_%+_%' OR mail LIKE '_%mail_%' OR mail LIKE '_%gmail_%';

/*44. Выбрать фамилию и инициалы преподавателей, id которых вне диапазона от 2 до 12, и в e-mail которых не входят символы %, ., &, но входит символ _ или ‒. Результат отсортировать в лексикографическом порядке.*/
SELECT surname + ' '+ LEFT(name,1) + '.' + ISNULL(' '+LEFT(patronymic, 1)+'.',' ') AS ФИО
FROM teachers
WHERE id BETWEEN 2 AND 12 AND [e-mail]  LIKE '_%[^%.&]_%' AND [e-mail] LIKE '_%[_-]_%'
ORDER BY surname DESC, LEFT(name,1) DESC, LEFT(patronymic,1) DESC;

/*-------------------------------------------------------------------------------------------------------------------------------------------------
  10 03 2022
-------------------------------------------------------------------------------------------------------------------------------------------------*/

/*0. Выбрать ФИО студента и его возраст.*/
SELECT surname + ' ' + name + ' ' + ISNULL(patronymic,'') AS ФИО, (CASE WHEN (MONTH(birthday)>=MONTH(GETDATE())
                      AND  DAY(birthday)>DAY(GETDATE())) 
                      THEN DATEDIFF(year, birthday,GETDATE())-1
                      ELSE DATEDIFF(year, birthday,GETDATE()) 
        end) AS Возраст
FROM students;

/*4. Выбрать все уникальные года рождения студентов. Результат отсортировать по годам в порядке убывания.*/
SELECT DISTINCT YEAR(birthday)
FROM students
ORDER BY YEAR(birthday) DESC;

/*11. Выбрать ФИО и дату рождения преподавателей. Если для преподавателя не указана дата рождения, то в соответствующем столбце указать сообщение 'Узнать дату рождения!'*/
SELECT surname + ' ' + name + ' ' + ISNULL(patronymic,'') AS ФИО, ISNULL(CAST(birthday AS NVARCHAR(21)),'Узнать дату рождения!')
FROM teachers;

/*14. Выбрать фамилию, имя, отчество преподавателей, у которых нет руководителя. Напротив каждого преподавателя в отдельном столбце указать сообщение ‘руководителя нет’.*/
SELECT surname, name, patronymic, 'руководителя нет' 
FROM teachers
WHERE head_of_teacher_id IS NULL;

/*16. Выбрать все данные о тех студентах нечетных курсов, кто отмечает день рождение в текущем месяце. Результат отсортировать по дате рождения.*/
SELECT *
FROM students
WHERE (course % 2) = 1 AND MONTH(birthday)=MONTH(GETDATE())
ORDER BY birthday;

/*30. Выбрать все данные о студентах, в фамилии, имени или отчестве которых есть ‘Иван’.*/
SELECT *
FROM students
WHERE name LIKE '%Иван%' OR surname LIKE '%Иван%' OR patronymic LIKE '%Иван%';

/*31. Выбрать названия дисциплин, которые состоят из более чем одного слова.*/
SELECT name
FROM disciplines
WHERE name LIKE '% %';

/*34. Выбрать названия дисциплин, которые состоят ровно из 2 слов.*/
SELECT name 
FROM disciplines
WHERE name LIKE '% %' AND name NOT LIKE '% % %';

/*35. Выбрать названия дисциплин, которые состоят ровно из 3 слов и более.*/
SELECT name
FROM disciplines
WHERE name LIKE '% % %';

/*33. Выбрать все данные о дисциплинах, в коде которых есть символ _. Результат отсортировать по коду.*/
SELECT *
FROM disciplines
WHERE code_discipline LIKE '%@_%' ESCAPE '@'
ORDER BY code_discipline;

/*36. Выбрать названия дисциплин, код которых состоит только из цифр. Результат отсортировать по коду дисциплины. (используйте деалект T-SQL)*/
SELECT name
FROM disciplines
WHERE code_discipline NOT LIKE '%[^0-9]%'
ORDER BY code_discipline;

/*37. Выбрать фамилию и инициалы студентов, в фамилии которых вторая буква а.*/
SELECT surname + ' ' + LEFT(name,1) + '.' + ISNULL(' '+LEFT(patronymic, 1)+'.',' ') AS 'фамилия и инициалы'
FROM students
WHERE surname LIKE '_а%';

/*38. Выбрать фамилию и инициалы студентов, в фамилии которых первая и последняя буквы а. Фамилии и инициалы необходимо вывести прописными буквами.*/
SELECT UPPER(surname + ' ' + LEFT(name,1) + '.' + ISNULL(' '+LEFT(patronymic, 1)+'.',' ')) AS 'фамилия и инициалы'
FROM students
WHERE surname LIKE 'a%a';

/*39. Выбрать все данные о преподавателях, в e-mail которых до символа @ ровно три символа.*/
SELECT *
FROM teachers
WHERE [e-mail] LIKE '___@%';

/*47. Выбрать фамилию, имя, дату рождения, курс, группу студентов в одном столбце. В результат должны войти данные только о студентах четных курсов. Результат отсортировать по этому столбцу.*/
SELECT surname + ' ' + name + ' ' + CAST(birthday AS NVARCHAR(21)) + ' ' + CAST(course AS NVARCHAR(21)) + ' ' + CAST([group] AS NVARCHAR(21))
FROM students
WHERE (course % 2) = 0
ORDER BY surname;

/*49. Выбрать фамилию, имя, отчество студентов, и если студент четвертого курса, то в последнем столбце результирующей таблицы вывести сообщение “Выпускник”.
Результат отсортировать следующим образом: в первую очередь студенты второго и третьего курса, а затем студенты других курсов, и по фамилии, имени и отчеству в лексикографическом порядке.*/
SELECT surname, name, ISNULL(patronymic,'') AS patronymic, CASE WHEN course=4 THEN 'Выпускник' ELSE '' END
FROM students
ORDER BY CASE WHEN course IN (2,3) THEN 1 ELSE 2 END,surname, name, patronymic;

/*46. Выбрать все данные о студентах с фамилиями, заканчивающимися на букву ц, изменив фамилию следующим образом: добавить в конец фамилии -енков.*/
SELECT id, CASE WHEN surname LIKE'%ц' THEN surname+'енков' ELSE surname END AS surname, name, ISNULL(patronymic,'') AS patronymic, birthday, course, [group], ISNULL([grant],'') AS [grant], faculty_id, mail 
FROM students;

/*2. Выбрать размеры максимального и минимального окладов.*/
SELECT MAX(salary) AS max, MIN(salary) AS min
FROM posts;

/*6. Выбрать количество различных имен студентов.*/
SELECT COUNT(DISTINCT name)
FROM students;

/*7. Выбрать количество студентов на втором курсе в 10 группе.*/
SELECT COUNT(*)
FROM students
WHERE course=2 AND [group]=10;

/*10. Выбрать максимальную, минимальную, среднюю и суммарную стипендию на 2 курсе в 10 группе.*/
SELECT MAX([grant]), MIN([grant]), AVG(ISNULL([grant],0) /*[grant]*/), SUM([grant])
FROM students
WHERE course=2 AND [group]=10;

/*13. Выбрать средний возраст студентов второго курса.*/
SELECT AVG(CASE WHEN (MONTH(birthday)>=MONTH(GETDATE())
                      AND  DAY(birthday)>DAY(GETDATE())) 
                      THEN DATEDIFF(year, birthday,GETDATE())-1
                      ELSE DATEDIFF(year, birthday,GETDATE())
			    END) AS Age
FROM students
WHERE course = 2;

SELECT course, COUNT(*)
FROM students
WHERE MONTH(birthday) IN (3,4,5)
GROUP BY course;

/*-------------------------------------------------------------------------------------------------------------------------------------------------
  24 03 2022
-------------------------------------------------------------------------------------------------------------------------------------------------*/

/*3. Выбрать для каждого курса дату рождения самого молодого студента на курсе.*/
SELECT course, MAX(birthday) 'birthday'
FROM students
GROUP BY course;

/*4. Выбрать группы, в которых не более 10 студентов.*/
SELECT course, [group]
FROM students
GROUP BY course, [group]
HAVING COUNT(*) <= 10

/*5. Выбрать для каждого года количество студентов, рожденных в этот год. Результат отсортировать по количеству студентов в порядке убывания.*/
SELECT COUNT(*) AS students, YEAR(birthday) 'birthday'
FROM students
GROUP BY YEAR(birthday)
ORDER BY 1 DESC;

/*6. Выбрать для каждого id_факультета средний возраст преподавателей.*/
SELECT faculty_id, AVG(CASE WHEN (MONTH(birthday)>=MONTH(GETDATE())
                      AND  DAY(birthday)>DAY(GETDATE())) 
                      THEN DATEDIFF(year, birthday,GETDATE())-1
                      ELSE DATEDIFF(year, birthday,GETDATE())
			    END) 'Age'
FROM teachers
GROUP BY faculty_id;

/*7. Выбрать номер месяца и количество первокурсников, рожденных в этот месяц.*/
SELECT MONTH(birthday) AS MOUNTH, COUNT(*) 'countFirstCourseStudents'
FROM students
WHERE course = 1
GROUP BY MONTH(birthday);

/*8. Выбрать имя и количество студентов с этим именем. В результат включить имена, которые есть у пяти и более студентов. Результат отсортировать по имени в лексикографическом порядке.*/
SELECT name, COUNT(*) 'countName'
FROM students
GROUP BY name
HAVING COUNT(*) >= 5
ORDER BY 1;

/*9. Выбрать для факультетов с id равному 2, 3, 5, 7 количество преподавателей. В результат включать факультеты, на которых более 100 преподавателей.*/
SELECT COUNT(*) 'countTeachers'
FROM teachers
WHERE faculty_id IN (2, 3, 5, 7)
GROUP BY faculty_id
HAVING COUNT(*) > 100;

/*10. Выбрать размер максимальной стипендии на втором и первом курсах.*/
SELECT MAX([grant]) 'grant'
FROM students
WHERE course IN (1, 2)
GROUP BY course;

/*11. Выбрать фамилию и количество студентов на первом и втором курсах с этой фамилией. В результат включить только те фамилии, которые есть хотя бы у трех студентов. Результат отсортировать в порядке обратном лексикографическому.*/
SELECT surname, COUNT(*) 'countStudents'
FROM students
WHERE course IN (1, 2)
GROUP BY course, surname
HAVING COUNT(*) >= 3
ORDER BY 1 DESC;

/*12. Выбрать год и количество рожденных в этот год. Количество рожденных должно быть распределено по временам года. В результирующей таблице должно быть пять столбцов (год в первом столбце и названия времен года в последующих).*/
SELECT YEAR(birthday) 'Год рождения', COUNT(CASE WHEN MONTH(birthday) IN (12, 1, 2)THEN 1 ELSE NUll END) 'Зима', 
									  COUNT(CASE WHEN MONTH(birthday) IN (3, 4, 5)THEN 1 ELSE NUll END) 'Весна',
									  COUNT(CASE WHEN MONTH(birthday) IN (6, 7, 8)THEN 1 ELSE NUll END) 'Лето',
									  COUNT(CASE WHEN MONTH(birthday) IN (9, 10, 11)THEN 1 ELSE NUll END) 'Осень'
FROM students
GROUP BY YEAR(birthday)
ORDER BY 1;


/*13. Для каждой даты вывести количество поставленных пятерок, четверок, троек. Результат отсортировать в порядке возрастания дат.*/
SELECT date, COUNT(CASE WHEN mark=5 THEN 1 ELSE NULL END) '5',
			 COUNT(CASE WHEN mark=4 THEN 1 ELSE NULL END) '4',
			 COUNT(CASE WHEN mark=3 THEN 1 ELSE NULL END) '3'
FROM performance
WHERE mark IN (3,4,5)
GROUP BY date
ORDER BY date;

/*14. Выбрать фамилии, которые носят ровно 3 студента.*/
SELECT surname
FROM students
GROUP BY surname
HAVING COUNT(*) = 3;

/*15. Выбрать курсы, на которых есть группы по 25 человек и более.*/
SELECT course
FROM students
GROUP BY course, [group]
HAVING COUNT(*) >= 25;

/*-------------------------------------------------------------------------------------------------------------------------------------------------
  31 03 2022
-------------------------------------------------------------------------------------------------------------------------------------------------*/ 

/*1. Выбрать название факультета и фамилию имя отчество декана факультета. Результат отсортировать по названию факультета в лексикографическом порядке.*/
SELECT fct.name, tcr.surname + ' ' + tcr.name + ' ' + ISNULL(tcr.patronymic,'') 'ФИО'
FROM faculties fct 
	JOIN teachers tcr ON (fct.dean_id = tcr.id)
ORDER BY 1;

/*2. Выбрать все данные о деканах, которые преподают математический анализ.*/
SELECT tcr.*
FROM faculties fct
	JOIN teachers tcr ON fct.id = tcr.faculty_id
	JOIN performance prm ON tcr.id = prm.teacher_id
	JOIN disciplines dcp ON dcp.id = prm.discipline_id
WHERE dcp.name = 'математический анализ';

/*3. Выбрать фамилию, имя, отчество преподавателей в одном столбце, во втором столбце название должности, дату вступления и дату выхода из должности.*/
SELECT tcr.surname + ' ' + tcr.name + ' ' + ISNULL(tcr.patronymic,'') 'ФИО', pst.name + ' ' + CAST(pst_tcr.entry_date AS nvarchar(21)) + ISNULL(' ' + CAST(pst_tcr.leave_date AS nvarchar(21)),'') 'название должности, дату вступления и дату выхода из должности' 
FROM teachers tcr
	JOIN post_teachers pst_tcr ON tcr.id = pst_tcr.teacher_id
	JOIN posts pst ON pst.id = pst_tcr.post_id;

/*4. Выбрать фамилию и инициалы преподавателя в одном столбце, во втором столбце название текущей должности, т.е. актуальной на данный момент.*/
SELECT tcr.surname + ' '+ LEFT(tcr.name,1) + '.' + ISNULL(' '+LEFT(tcr.patronymic, 1)+'.',' ') 'ФИО', pst.name 'название должности' 
FROM teachers tcr
	JOIN post_teachers pst_tcr ON tcr.id = pst_tcr.teacher_id
	JOIN posts pst ON pst.id = pst_tcr.post_id
WHERE pst_tcr.leave_date IS NULL;

/*5. Найти однофамильцев среди преподавателей и студентов.*/
SELECT tcr.surname + ' ' + tcr.name + ' ' + ISNULL(tcr.patronymic, '') 'Преподаватель', std.surname + ' ' + std.name + ' ' + ISNULL(std.patronymic, '') 'Студент'
FROM students std
	JOIN teachers tcr ON std.surname = tcr.surname;

/*6. Выбрать название факультета, курс, группу, фамилию и инициалы студентов, которые учатся на факультете, название дисциплины, дату экзамена,
оценку, фамилию и инициалы преподавателя, поставившего оценку и название текущей должности преподавателя.
Результат отсортировать по названию факультета в порядке обратном лексикографическому, по курсу и группе в возрастающем порядке, по фамилии, имени, отчеству студентов в лексикографическом порядке.*/
SELECT fct.name, std.course, std.[group], std.surname + ' ' + LEFT(std.name,1) + ' ' + ISNULL(std.patronymic,'') 'ФИО студента', dcp.name, prm.date,
	prm.mark, tcr.surname + ' '+ LEFT(tcr.name,1) + '.' + ISNULL(' '+LEFT(tcr.patronymic, 1)+'.',' ') 'ФИО преподавателя', pst.name
FROM faculties fct
	JOIN students std ON fct.id = std.faculty_id
	JOIN performance prm ON std.id = prm.student_number_id
	JOIN disciplines dcp ON dcp.id = prm.discipline_id
	JOIN teachers tcr ON tcr.id = prm.teacher_id
	JOIN post_teachers pst_tcr ON tcr.id = pst_tcr.teacher_id 
	JOIN posts pst ON pst.id = pst_tcr.post_id
ORDER BY 1 DESC, 2, 3, std.surname, std.name, std.patronymic;

/*7. Для каждой дисциплины, сдававшейся в зимнюю сессию текущего учебного года, вывести название, фамилию и инициалы преподавателя, среднюю оценку по дисциплине,
количество студентов, сдавших дисциплину на отлично, количество студентов, сдавших дисциплину хорошо, количество студентов, сдавших дисциплину удовлетворительно,
количество студентов, не сдавших дисциплину, общее количество студентов, сдававших дисциплину.*/
SELECT dcp.name, tcr.surname + ' ' + LEFT(tcr.name,1) + ' ' + ISNULL(tcr.patronymic,'') 'ФИО преподавателя', AVG(prm.mark) 'среднюю оценку по дисциплине', COUNT(CASE WHEN prm.mark = 5 THEN 1 ELSE NULL END) 'количество студентов, сдавших дисциплину на отлично',
	COUNT(CASE WHEN prm.mark = 4 THEN 1 ELSE NULL END) 'количество студентов, сдавших дисциплину хорошо', COUNT(CASE WHEN prm.mark = 3 THEN 1 ELSE NULL END) 'количество студентов, сдавших дисциплину удовлетворительно',
	COUNT(CASE WHEN prm.mark = 2 OR prm.mark IS NULL THEN 1 ELSE NULL END) 'количество студентов, не сдавших дисциплину', COUNT(CASE WHEN prm.mark IN (5,4,3) THEN 1 ELSE NULL END) 'общее количество студентов, сдававших дисциплину'
FROM disciplines dcp
	JOIN performance prm ON dcp.id = prm.discipline_id
	JOIN teachers tcr ON tcr.id = prm.teacher_id
WHERE MONTH(prm.date) = 1 AND YEAR(prm.date) = YEAR(GETDATE()) OR MONTH(prm.date) = 12 AND YEAR(prm.date) = YEAR(GETDATE()) - 1
GROUP BY dcp.id, dcp.name, tcr.id, tcr.surname, tcr.name, tcr.patronymic;

/*8. Выбрать название факультета, фамилию и инициалы студентов, название дисциплины, дату, оценку, фамилию и инициалы преподавателя, текущую должность преподавателя.*/
SELECT fct.name, std.surname + ' ' + LEFT(std.name,1) + ' ' + ISNULL(std.patronymic,'') 'ФИО студента', dcp.name, prm.date, prm.mark, tcr.surname + ' ' + LEFT(tcr.name,1) + ' ' + ISNULL(tcr.patronymic,'') 'ФИО преподавателя', pst.name
FROM faculties fct
	JOIN students std ON fct.id = std.faculty_id
	JOIN performance prm ON std.id = prm.student_number_id
	JOIN teachers tcr ON tcr.id = prm.teacher_id
	JOIN disciplines dcp ON dcp.id = prm.discipline_id
	JOIN post_teachers pst_tcr ON tcr.id = pst_tcr.teacher_id
	JOIN posts pst ON pst.id = pst_tcr.post_id;

/*9. Выбрать фамилию, имя, отчество всех преподавателей, и, если преподаватель имеет руководителя, то фамилию и инициалы его руководителя.*/
SELECT tcr.surname, tcr.name, ISNULL(tcr.patronymic,'') 'patronymic', ISNULL(t.surname + ' '+ LEFT(t.name,1) + '.' + ISNULL(' '+LEFT(t.patronymic, 1)+'.',' '),'') 'ФИО преподавателя'
FROM teachers tcr
	LEFT JOIN teachers t ON tcr.head_of_teacher_id = t.id;

/*10. Выбрать курс, группу, фамилию, имя, отчество студента, и, если студент сдал дисциплину на 5, то название дисциплины.*/
SELECT std.course, std.[group], std.surname, std.name, ISNULL(std.patronymic,'') 'patronymic', CASE WHEN prm.mark = 5 THEN dcp.name ELSE '' END 'название дисциплины'
FROM disciplines dcp 
	JOIN performance prm ON dcp.id = prm.discipline_id
	JOIN students std ON std.id = prm.student_number_id;

/*12. Выбрать названия всех факультетов и фамилии и инициалы деканов. Учесть, что в БД могут быть факультеты, для которых не указан декан. Результат отсортировать по названию факультета в лексикографическом порядке.*/
SELECT fct.name, ISNULL(tcr.surname + ' '+ LEFT(tcr.name,1) + '.' + ISNULL(' '+LEFT(tcr.patronymic, 1)+'.',' '),'') 'ФИО преподавателя'
FROM faculties fct
	LEFT JOIN teachers tcr ON fct.dean_id = tcr.id
ORDER BY 1;

/*13. Выбрать названия всех должностей и количество преподавателей в соответствующей должности на данный момент. Учесть, что в БД могут быть вакантные должности.*/
SELECT pst.name, COUNT(pst_tcr.teacher_id) 'количество преподавателей в соответствующей должности на данный момент'
FROM post_teachers pst_tcr
	RIGHT JOIN posts pst ON pst.id = pst_tcr.post_id
GROUP BY pst.id, pst.name;

/*14. Выбрать курс, группу, фамилию, имя, отчество всех студентов, названия всех дисциплин как тех, которые сдавались студентами, так и тех, которые не сдавались, если дисциплина сдавалась студентом, то указать фамилию и инициалы преподавателя.*/
SELECT std.course, std.[group], std.surname, std.name, ISNULL(std.patronymic,'') 'patronymic', dcp.name, ISNULL(tcr.surname + ' '+ LEFT(tcr.name,1) + '.' + ISNULL(' '+LEFT(tcr.patronymic, 1)+'.',' '),'') 'ФИО преподавателя'
FROM students std
	LEFT JOIN performance prm ON std.id = prm.student_number_id
	FULL JOIN disciplines dcp ON dcp.id = prm.discipline_id
	LEFT JOIN teachers tcr ON tcr.id = prm.teacher_id;

/*-------------------------------------------------------------------------------------------------------------------------------------------------
  07 04 2022
-------------------------------------------------------------------------------------------------------------------------------------------------*/ 

/*0. Посчистать количество однофамильцев среди студентов.*/
SELECT surname, COUNT(*) 'количество однофамильцев среди студентов'
FROM students
GROUP BY surname
HAVING COUNT(*) > 1;

/*15. Вывести названия всех дисциплин, и, если есть студенты, сдавшие этот предмет на 4 и 5, то количество таких студентов.*/
SELECT dcp.name, COUNT(CASE WHEN prm.mark IN (4, 5) THEN 1 ELSE NULL END) 'количество студентов сдавшие на 4 и 5'
FROM disciplines dcp
	LEFT JOIN performance prm ON dcp.id = prm.discipline_id-- AND prm.mark IN (4, 5)
GROUP BY dcp.id, dcp.name;

/*16. Выбрать название факультета, фамилию, имя, отчество декана, количество преподавателей, работающих на факультете.*/
SELECT fct.name, ISNULL(dcn.surname,'') 'surname', ISNULL(dcn.name,'') 'name', ISNULL(dcn.patronymic,'') 'patronymic', COUNT(tcr.id) 'количество преподавателей, работающих на факультете'
FROM faculties fct
	LEFT JOIN teachers tcr ON fct.id = tcr.faculty_id
	LEFT JOIN teachers dcn ON dcn.id = fct.dean_id
GROUP BY fct.id, fct.name, dcn.id, dcn.surname, dcn.name, dcn.patronymic;

/*17. Вывести средний и суммарный баллы для каждого студента.*/
SELECT ROUND(AVG(CAST(prm.mark AS float)),2) 'средний балл', SUM(prm.mark) 'суммарный балл' --ROUND(SUM(CAST(prm.mark AS float))/COUNT(prm.mark),2)
FROM performance prm
	RIGHT JOIN students std ON std.id = prm.student_number_id
GROUP BY std.id;

/*18. Выбрать фамилию, имя студента курс, группу, среднюю оценку студента.*/
SELECT std.surname, std.name, std.course, std.[group], ROUND(AVG(CAST(prm.mark AS float)),2) 'средний балл'
FROM students std
	LEFT JOIN performance prm ON std.id = prm.student_number_id
GROUP BY std.id, std.surname, std.name, std.course, std.[group];

/*19. Выбрать названия всех дисциплин. Если есть студенты, сдавшие экзамен по дисциплине, то среднюю оценку.*/
SELECT dcp.name, ISNULL(CAST(ROUND(AVG(CAST(prm.mark AS float)),2) AS nvarchar(4)),'') 'средний балл'--, ISNULL(ROUND(AVG(CAST(prm.mark AS float)),2),'') 'средний балл'
FROM disciplines dcp
	LEFT JOIN performance prm ON dcp.id = prm.discipline_id
	--LEFT JOIN students std ON std.id = prm.student_number_id
GROUP BY dcp.id, dcp.name;

/*20. Выбрать количество студентов, получивших неудовлетворительные оценки за последнюю зимнюю сессию.*/
SELECT COUNT(DISTINCT prm.student_number_id) 'количество студентов, получивших неудовлетворительные оценки за последнюю зимнюю сессию'
FROM performance prm
	--JOIN students std ON std.id = prm.student_number_id
WHERE prm.mark = 2 AND (MONTH(prm.date) = 1 AND YEAR(prm.date) = YEAR(GETDATE()) OR MONTH(prm.date) = 12 AND YEAR(prm.date) = YEAR(GETDATE()) - 1);

/*21. Выбрать день, в который было сдано больше N дисциплин.*/
SELECT DAY(prm.date) 'Выбрать день, в который было сдано больше N дисциплин'
FROM disciplines dcp
	JOIN performance prm ON dcp.id = prm.discipline_id
GROUP BY prm.date
HAVING COUNT(*) > 1;

/*22. Выбрать названия всех факультетов, фамилии и инициалы деканов, количество студентов и количество преподавателей на факультете. Учесть, что в БД могут быть факультеты, для которых не указан декан, а также для недавно созданных (новых) факультетов может еще не быть зачисленных студентов и/или преподавателей.*/
SELECT fct.name, dcn.surname + ' ' + LEFT(dcn.name, 1) + '.' + ISNULL(' ' + LEFT(dcn.patronymic, 1) + '.','') 'Фамилия и инициалы', COUNT(DISTINCT std.id), COUNT(DISTINCT tcr.id) 
FROM faculties fct
	LEFT JOIN teachers tcr ON fct.id = tcr.faculty_id
	LEFT JOIN teachers dcn ON fct.dean_id = dcn.id
	LEFT JOIN students std ON fct.id = std.faculty_id
GROUP BY fct.id, fct.name, dcn.id, dcn.surname, dcn.name, dcn.patronymic;

/*31. Выбрать все данные студента, который старше какого-нибудь преподавателя.*/
SELECT DISTINCT std.*
FROM students std
	JOIN teachers tcr ON tcr.birthday > std.birthday;

/*33. Выбрать тройки однофамильцев среди студентов.*/
SELECT s1.id, s2.id, s3.id
FROM Students s1
	JOIN Students s2 ON s1.surname = s2.surname
	JOIN Students s3 ON s2.surname = s3.Surname
WHERE s1.id > s2.id AND s2.id > s3.id;

/*37. Для каждого студента факультета ПММ выбрать названия всех имеющихся в БД дисциплин.*/
SELECT std.id, dcp.name
FROM students std
	CROSS JOIN disciplines dcp
	JOIN faculties fct ON fct.id = std.faculty_id
WHERE fct.name LIKE 'ПММ'; --без UPPER тоже работает

/*44. Выбрать фамилию, имя, отчество преподавателей факультета ПММ, средняя оценка у которых ниже 3.7.*/
SELECT tcr.surname, tcr.name, ISNULL(tcr.patronymic,'') 'patronymic'--, prm.discipline_id
FROM teachers tcr
	JOIN faculties fct ON fct.id = tcr.faculty_id
	JOIN performance prm ON tcr.id = prm.teacher_id
WHERE fct.name LIKE 'ПММ'
GROUP BY tcr.id, tcr.surname, tcr.name, tcr.patronymic, prm.teacher_id--, prm.discipline_id
HAVING ROUND(AVG(CAST(prm.mark AS float)),2) < 3.7

/*-------------------------------------------------------------------------------------------------------------------------------------------------
  21 04 2022
-------------------------------------------------------------------------------------------------------------------------------------------------*/

/*2. Выбрать название должностей с минимальным окладом.*/
SELECT pst.name
FROM posts pst
WHERE pst.salary = (
	SELECT MIN(salary)
	FROM posts
);

/*3. Выбрать все данные о преподавателях, получающих максимальный оклад.*/
SELECT thr.*
FROM teachers thr
JOIN post_teachers pst_tcr
	ON thr.id = pst_tcr.teacher_id
JOIN posts pst
	ON pst.id = pst_tcr.post_id
WHERE pst.salary = (
	SELECT MAX(p.salary)
	FROM  posts p
);

/*4. Выбрать все данные о самом молодом преподавателе.*/
SELECT *
FROM teachers tcr
WHERE tcr.birthday = (
	SELECT MAX(t.birthday)
	FROM teachers t
);

/*5. Выбрать все данные о самом молодом и самом старшем преподавателях.*/
SELECT tcr.*
FROM teachers tcr
WHERE tcr.birthday = (
	SELECT MAX(t.birthday)
	FROM teachers t
)
OR tcr.birthday = (
	SELECT MIN(t.birthday)
	FROM teachers t
);

/*6. Выбрать название должностей с минимальным окладом.*/
SELECT pst.name
FROM posts pst
WHERE pst.salary = (
	SELECT MIN(p.salary)
	FROM posts p
);

/*7. Выбрать группы, в которых учиться столько же студентов, сколько на 2 курсе в 10 группе.*/
SELECT std.[group]
FROM students std
GROUP BY std.course, std.[group]
HAVING COUNT(*) = (
	SELECT COUNT(*)
	FROM students s
	WHERE s.course = 2 AND s.[group] = 10
);

/*8. Выбрать названия дисциплин, которые сдавались студентами 2 курса 10 группой.*/
SELECT DISTINCT dcp.name
FROM disciplines dcp
JOIN performance prm
	ON dcp.id = prm.discipline_id
JOIN students std
	ON std.id = prm.student_number_id
WHERE std.course = 2 AND std.[group] = 10;

/*9. Выбрать все данные преподавателей, которые работают на одном факультете с преподавателем Ивановым Иван Ивановичем.*/
SELECT tcr.*
FROM teachers tcr
JOIN faculties fct
	ON fct.id = tcr.faculty_id
WHERE fct.id = (
	SELECT f.id
	FROM faculties f
	JOIN teachers t
		ON f.id = t.faculty_id
	WHERE TRIM(t.name) LIKE 'Иван' AND TRIM(t.surname) LIKE 'Иванов' AND TRIM(t.patronymic) LIKE 'Иванович'
);

/*10. Выбрать названия факультетов, на которых средняя стипендия ниже средней стипендии на факультете ПММ.*/
SELECT fct.name
FROM faculties fct
JOIN students std
	ON fct.id = std.faculty_id
GROUP BY fct.id, fct.name
HAVING AVG(std.[grant]) = (
	SELECT AVG(s.[grant])
	FROM students s
	JOIN faculties f
		ON f.id = s.faculty_id
	WHERE TRIM(f.name) LIKE 'ПММ'
);

/*14. Выбрать все данные о студентах, которые учатся на курсах, на которых менее 1000 студентов.*/
SELECT std.*
FROM students std
WHERE std.course = (
	SELECT course
	FROM students
	GROUP BY course
	HAVING COUNT(*) < 1000
);

/*20. Вывести фамилию, имя, отчество студентов, обучающихся в группах, в которых менее 12 человек.*/
SELECT std.surname, std.name, ISNULL(patronymic, '') patronymic
FROM students std
WHERE std.[group] IN (
	SELECT s.[group]
	FROM students s
	WHERE std.[group] = s.[group]
	GROUP BY s.[group]
	HAVING COUNT(*) < 12
);

/*-------------------------------------------------------------------------------------------------------------------------------------------------
  28 04 2022
-------------------------------------------------------------------------------------------------------------------------------------------------*/

/*0. Выбрать id_преподавателя, фамилию, имя, отчество преподавателя, которой получает максимальный оклад на своем факультете.*/
SELECT tcr.id, tcr.surname, tcr.name, ISNULL(tcr.patronymic, '') patronymic
FROM teachers tcr
JOIN post_teachers pst_tcr
	ON tcr.id = pst_tcr.teacher_id
JOIN posts pst
	ON pst.id = pst_tcr.post_id
WHERE pst.salary = (
	SELECT MAX(p.salary)
	FROM teachers t
	JOIN post_teachers pt
		ON t.id = pt.teacher_id
	JOIN posts p
		ON p.id = pt.post_id
	WHERE tcr.faculty_id = t.faculty_id
);

/*1. Выбрать данные о самом молодом и самом старшем студентах в каждой группе.*/
SELECT std.*
FROM students std
WHERE std.birthday = (
	SELECT MAX(s.birthday)
	FROM students s
	WHERE s.course = std.course AND s.[group] = std.[group]
	GROUP BY s.course, s.[group]
)
OR std.birthday = (
	SELECT MIN(s.birthday)
	FROM students s
	WHERE s.course = std.course AND s.[group] = std.[group]
	GROUP BY s.course, s.[group]
);

SELECT std.*
FROM students std
JOIN (
	SELECT  s.course, s.[group], MAX(s.birthday) Yongest, MIN(s.birthday) Oldest
	FROM students s
	GROUP BY s.course, s.[group]
) yOrO
	ON std.course = yOrO.course AND std.[group] = yOrO.[group]
WHERE std.birthday = yOrO.Oldest OR std.birthday = yOrO.Yongest

/*2. Выбрать данные о студентах, средний бал которых больше, чем средий бал группы.*/
SELECT std.*
FROM students std
WHERE (
	SELECT AVG(CAST(p.mark AS float))
	FROM performance p
	WHERE std.id = p.student_number_id
) > (
	SELECT AVG(CAST(p.mark AS float))
	FROM students s
	JOIN performance p
		ON s.id = p.student_number_id
	WHERE std.course = s.course AND std.[group] = s.[group]
);

/*16. Выбрать фамилии студентов, которые получают стипендию больше, чем средняя стипендия на их факультете.*/
SELECT std.surname
FROM students std
WHERE std.[grant] > (
	SELECT AVG(s.[grant])
	FROM students s
	WHERE s.faculty_id = std.faculty_id
);

/*18. Выбрать курсы и группы без повторений тех факультетов, на которых преподается дисциплина «Базы данных».*/
SELECT DISTINCT std.course, std.[group]
FROM students std
WHERE std.faculty_id IN (
	SELECT s.faculty_id
	FROM Students s
	JOIN Performance p 
		ON s.id = p.student_number_id
	JOIN Disciplines d 
		ON d.id = p.discipline_id
	WHERE TRIM(d.Name) LIKE 'Базы данных'
);

/*19. Выбрать по каждой должности ФИО преподавателя, который принят на работу в эту должность последними.*/
SELECT pst.Name, tcr.Surname, tcr.Name, ISNULL(tcr.Patronymic, '') patronymic
FROM posts pst
JOIN post_teachers pst_tcr
	ON pst_tcr.post_id = pst.id
JOIN teachers tcr 
	ON tcr.id = pst_tcr.teacher_id
WHERE pst_tcr.entry_date = (
	SELECT MAX(pt.entry_date)
	FROM post_teachers pt
	JOIN posts p 
		ON p.id = pt.post_id
	WHERE p.id = pst.id
);

/*22. Выбрать название факультета, ФИО декана, количество человек, работающих на факультете и общее количество человек, работающих в ВУЗе.*/
SELECT fct.name, tcr.Surname, tcr.Name, ISNULL(tcr.Patronymic, '') patronymic, (
	SELECT COUNT(*)
	FROM teachers t
	WHERE fct.id = t.faculty_id
), (
	SELECT COUNT(*)
	FROM teachers
)
FROM faculties fct
LEFT JOIN teachers tcr
	ON tcr.id = fct.dean_id;

/*29. Выбрать названия дисциплин, которые на 5 сдали 2/3 от всех сдававших.*/
SELECT dcp.name
FROM disciplines dcp
WHERE CAST(0.66 * (
	SELECT COUNT(*)
	FROM performance p
	WHERE dcp.id = p.discipline_id
) AS bigint) = (
	SELECT COUNT(*)
	FROM performance p
	WHERE dcp.id = p.discipline_id AND p.mark = 5
);

/*001. Выбрать названия дисциплин, для которых количество студентов, сдавших дисциплину на 5 и 4, превышает количество студентов, сдавших эту дисциплину на 3 и 2.*/
SELECT dcp.name
FROM disciplines dcp
WHERE (
	SELECT COUNT(*)
	FROM performance p
	WHERE dcp.id = p.discipline_id AND p.mark IN (4, 5)
) > (
	SELECT COUNT(*)
	FROM performance p
	WHERE dcp.id = p.discipline_id AND p.mark IN (2, 3)
);

/*-------------------------------------------------------------------------------------------------------------------------------------------------
  12 05 2022
-------------------------------------------------------------------------------------------------------------------------------------------------*/

/*11. Выбрать названия факультетов без преподавателей.*/
SELECT fct.name
FROM faculties fct
WHERE NOT EXISTS(
	SELECT 1
	FROM teachers tcr
	WHERE fct.id = tcr.faculty_id
);

/*12. Выбрать все данные о студентах, у которых еще не было сессии.*/
SELECT std.*
FROM students std
WHERE NOT EXISTS(
	SELECT 1
	FROM students s
	JOIN performance p
		ON s.id =p.student_number_id
	WHERE std.id = s.id
);

/*24. Вывести фамилии трех студентов с наибольшим средним балом. (TOP пользваться нельзя)*/
WITH AVGMarks AS (
	SELECT p.student_number_id, AVG(CAST(p.mark AS float)) avgMark
	FROM performance p
	GROUP BY p.student_number_id
)
SELECT std.surname, std.id
FROM AVGMarks am
JOIN students std
	ON std.id = am.student_number_id
WHERE 2 >= (
	SELECT COUNT(*)
	FROM AVGMarks a
	WHERE a.avgMark > am.avgMark
);

/*25. Вывести слова “Есть однофамильцы”, если есть однофамильцы по всей БД и вывести “Однофамильцев нет”, если таковых нет.*/
SELECT CASE WHEN EXISTS(
	SELECT std.surname
	FROM students std
	UNION ALL
	SELECT tcr.surname
	FROM teachers tcr
	GROUP BY surname
	HAVING COUNT(*) > 1
)
	THEN 'Есть однофамильцы'
	ElSE 'Однофамильцев нет'
	END 'Наличие однофамильцев';

/*26. Вывести в одном столбце ФИО студентов и преподавателей. Для преподавателей указать количество предметов, которые ведет преподаватель, для студентов -
количество предметов, по которым студент имеет оценку 5 или 4. Результат отсортировать по ФИО в лексикографическом порядке.*/
SELECT tcr.surname + ' ' + tcr.name + ISNULL(' ' + tcr.patronymic,'') 'ФИО', COUNT(DISTINCT prm.discipline_id) 'Количество предметов'
FROM teachers tcr
LEFT JOIN performance prm
	ON tcr.id = prm.teacher_id
GROUP BY tcr.id, tcr.surname, tcr.name, tcr.patronymic
UNION ALL
SELECT std.surname + ' ' + std.name + ISNULL(' ' + std.patronymic,''), COUNT(DISTINCT prm.discipline_id)
FROM students std
LEFT JOIN performance prm
	ON std.id =prm.student_number_id AND prm.mark IN (4, 5)
GROUP BY std.id, std.surname, std.name, std.patronymic

/*28. Выбрать названия дисциплин, которые на 5 сдали 2/3 от всех сдававших.*/
SELECT dcp.name
FROM disciplines dcp
WHERE CAST(0.67 * (
	SELECT COUNT(*)
	FROM performance p
	WHERE dcp.id = p.discipline_id
) AS int) = (
	SELECT COUNT(*)
	FROM performance p
	WHERE dcp.id = p.discipline_id AND p.mark = 5
) AND (
	SELECT COUNT(*)
	FROM performance p
	WHERE dcp.id = p.discipline_id AND p.mark = 5
) != 0;

