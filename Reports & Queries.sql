-------------------------------------------Reports & Queries-----------------------------------
-----------------------------------------------------------------------------------------------


-------1-Exam Generation (SP)-------
Create proc Create_Exam_course (@Exam_id int , @course_id varchar(10))
as
Begin

	Begin try
	if NOT EXISTS (SELECT 1 FROM Exams WHERE exam_id = @Exam_id)
	Begin
		Insert into Exams
		values (@Exam_id , @Course_id)
	End

        INSERT INTO Exam_Questions (exam_id, q_no)
        SELECT @Exam_id, q_no
        FROM (
            SELECT q_no, ROW_NUMBER() OVER (PARTITION BY topic_id ORDER BY NEWID()) AS RowNum
            FROM Questions
            WHERE topic_id IN (SELECT Topic_id FROM Topics where crs_id = @Course_id)
        ) AS RankedQuestions
        WHERE RowNum <= 3
	End try

	Begin catch
	Select 'this exam is in the database ' 
	End catch

End

Exec Create_Exam_course @Exam_id=4 , @course_id='c3'


-------To view the Exams and there Questions topics-----------
create view OrderedExams AS 
    select e.exam_id,  c.crs_name , t.topic_name
	from Exams e join Courses c ON e.crs_id = c.crs_id
                 join Topics t ON c.crs_id = t.crs_id
select * from OrderedExams order by exam_id;


--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------


-------2-Exam correction (SP)-------

---The student insert the answers---
Create type AnswerTableType AS Table
( answer VARCHAR(1) )

-------Inserting the answers from students---------
Create proc Student_put_answers (@Student_id int , @Exam_id int , @Answer AnswerTableType READONLY)
as
Begin
		 With NumberedQuestions AS (
			Select ROW_NUMBER() OVER (ORDER BY q_no) AS RowNum, q_no
			from Exam_questions
			where exam_id = @Exam_id
		), NumberedAnswers AS (
			select ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum, answer
			from @Answer
		)
    insert into Student_answers (st_id, exam_id, q_no, a_answer)
    Select @Student_id, @Exam_id, nq.q_no, na.answer
    from NumberedQuestions nq
    join NumberedAnswers na on nq.RowNum = na.RowNum;
		
End

DECLARE @Answer AnswerTableType
Insert into @Answer (answer)
Values  ('a'),
		('b'),
		('c'),
		('d'),
		('a'),
		('b')
EXEC Student_put_answers @Student_id = 2, @Exam_id = 4, @Answer = @Answer;

------check if the answer of student correct or not -----
Create proc Updating_and_Correcting_Each_Answers
as
UPDATE sa
SET sa.correct = case
                    WHEN qa.qa_isTrue = 0 THEN 0
                    WHEN qa.qa_isTrue = 1 THEN 1
                 end
FROM Student_answers sa
JOIN Questions q ON sa.q_no = q.q_no
JOIN Question_answers qa ON q.q_no = qa.q_no
WHERE sa.a_answer = qa.qa_letter;

Exec Updating_and_Correcting_Each_Answers

----count the correct answers---and insert into column grade table 
ALTER TRIGGER Correct_Exam
ON Student_answers
AFTER Update
as
Begin
	declare @St_id int 
	declare @Exam_id int 
	declare @TotalQuestions INT;
        declare @CorrectAnswers INT;
        declare @PassPercentage DECIMAL(5, 2);
    
    SET @PassPercentage = 0.6;

	
	select @St_id=st_id , @Exam_id = exam_id ,@CorrectAnswers= Count(correct) 
	from Student_answers where correct = 1 group by st_id , exam_id

	select @TotalQuestions = Count(correct)
	from Student_answers group by st_id , exam_id

	if @CorrectAnswers >= (@TotalQuestions * @PassPercentage)
		Begin
			Insert into Student_exams
			values (@St_id , @Exam_id , 'PASS' )
		End
	else
		Begin
			Insert into Student_exams
			values (@St_id , @Exam_id , 'FAIL' )
		End

End


--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------


-------3-Exam Answers (SP)-------
create proc examAnswers @exam_id int
as
	select E.exam_id as 'Exam ID',Q.q_no as 'question number',
		   question,qa_answer as 'answer'
	from Exams E
	join Exam_questions EQ
	on E.exam_id = EQ.exam_id
	join Questions Q
	on EQ.q_no = Q.q_no
	join Question_answers QA
	on Q.q_no = QA.q_no
	where qa_isTrue = 1 AND E.exam_id = @exam_id


--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------


-----4-Report that returns the students information according to Department No parameter-------
create view studentInfo 
as
	select st_id as 'Student ID',st_Fname+' '+st_Lname as 'Student Name',
	   dept_name as 'Student''s Department'
	from dbo.Students S
	join dbo.Departments D
	on S.dept_no = D.Dept_no



--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------


-------5-Report that takes the student ID and returns the grades of the student in all courses-------
Create view StudentGrades (StID, StFullName, StCourse, StGrade)
as 
	Select s.st_id, concat(s.st_Fname, ' ', s.st_Lname),
		c.crs_name, stexm.grade
	from Student_exams stexm inner join Students s
		on s.st_id = stexm.st_id 
		inner join Student_courses stcur
			on s.st_id = stcur.st_id
			inner join Courses c
				on c.crs_id = stcur.crs_id
				inner join Exams e
					on c.crs_id = e.crs_id and stexm.exam_id = e.exam_id
	group by s.st_id, concat(s.st_Fname, ' ', s.st_Lname), 
		c.crs_name, stexm.grade

Create proc GetStGrades @StID int
as
	Select *
	from StudentGrades
	where StID = @StID



--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------


----6-Report that takes the instructor ID and returns the name of the courses that he teaches and the number of students per course-----
Create proc GetInsCourses @InsID varchar(10)
as
	Select c.crs_name, Count(stc.st_id) as 'Num of Students'
	from Courses c inner join Student_courses stc
		on c.crs_id = stc.crs_id
			and c.inst_id = @InsID
	group by c.crs_name



--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------


--------7-Report that takes course ID and returns its topics-----------
Create function  course_ID_its_topics (@Course_Id varchar(10))
returns table
as
return (
select * from Topics where crs_id = @Course_Id
)

--select * from course_ID_its_topics('C1')



--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------


-------8-Report that takes exam number and returns the Questions in it--------
Create function exam_number_its_Questions (@exam_no int)
returns table
as
return (
select * from Exam_questions where exam_id = @exam_no)


--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------


-----9-Report that takes exam number, and the student ID then returns the Questions in this exam with the student answers------
create function Exam_Questions_Student_Answers (@Exam_no int , @st_id int)
returns @t TABLE (Questions varchar(255) , Answers varchar(1))
as
Begin
	Insert into @t
	select  q.question as Questions , sa.a_answer as Answers from Student_answers sa 
	join Questions q  on q.q_no = sa.q_no
	where sa.exam_id = @Exam_no and sa.st_id = @st_id
	return
End






