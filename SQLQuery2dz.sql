
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
GROUP BY 1;

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
