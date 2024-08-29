---------------------------------Stored Procedures----------------------------------
--------------------Insert----Update----Delete-----Select---------------------------


----------------------------------------------students -------------------------------------------------
--------------------------------------------------------------------------------------------------------


----------select all ------------ 
create proc SelectAllStudent 
as
begin
   select * from Students
end

------------insert --------------
create proc insertStudent @stFname varchar(50) , @stLname varchar(50) , @deptNo varchar(50)
as

  begin try
	insert into Students values (@stFname , @stLname , @deptNo)

  end try
  begin catch
	Select ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_LINE()
  end catch

----------update-----------
create proc updateStudent @stId int , @stFname varchar(50) , @stLname varchar(50) , @deptNo varchar(50) 
as
begin try
   update Students  
   set st_Fname =@stFname , st_Lname = @stLname ,dept_no = @deptNo
   where st_id = @stId
end try
begin catch
	Select ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_LINE()
end catch


-----------delete-----------
create proc DeleteStudent @stId int 
as
begin
delete Students  
where st_id = @stId
end






-----------------------------------------------Courses-------------------------------------------------
-------------------------------------------------------------------------------------------------------


----------select all ------------ 
create proc SelectAllCourses
as
begin
select * from Courses
end


-----------insert ------------ 
create proc insertCourses @crsId varchar(10) , @crsName varchar(50) , @instId varchar(10)
as
begin
insert into Courses values (@crsId , @crsName , @instId)
end


----------update-----------
create proc updateCourses @crsId varchar(10) , @crsName varchar(50) , @instId varchar(10)
as
begin
update Courses  
set crs_id =@crsId , crs_name = @crsName ,inst_id = @instId
where crs_id = @crsId
end


----------delete----------
create proc DeleteCourses @crsId int 
as
begin
delete Courses  
where crs_id = @crsId
end






-----------------------------------------------Departments-------------------------------------------------
-----------------------------------------------------------------------------------------------------------


----------select all ------------
create proc Departments_Select
as
	select * from Departments


------------insert --------------
create proc Departments_Insert @D_Number varchar(10),@D_name varchar(50)
as
	begin try
		insert into Departments
		values(@D_Number,@D_name)
	end try
	begin catch
		select 'The Department Number already exists,Please choose another one'
	end catch


----------update-----------
create proc Departments_Update @D_Number_old varchar(10),@D_Number_new varchar(10),@D_name_new varchar(50)
as
	begin try
		update dbo.Departments
				set Dept_no = (case when @D_Number_new is not null then @D_Number_new else @D_Number_old end),
					Dept_name = (case when @D_name_new is not null then @D_name_new else Dept_name end)
				where Dept_no=@D_Number_old
	end try
	begin catch
		Select 'Faild to update Department ' + @D_Number_old
		Select ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_LINE()
	end catch



----------Delete-----------
create proc Departments_Delete @D_Number varchar(10)
as
	begin try
		delete from dbo.Departments
		where Dept_no=@D_Number
	end try
	begin catch
		Select 'Faild to update Department ' + @D_Number
		Select ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_LINE()
	end catch






-----------------------------------------------Instructor -------------------------------------------------
-----------------------------------------------------------------------------------------------------------


----------Select-----------
create proc Inst_Select
as
	select * from Instructors


----------Insert-----------
create proc Inst_Insert @I_Number varchar(10),@I_name varchar(50)
as
	begin try
		insert into dbo.Instructors
		values(@I_Number,@I_name)
	end try
	begin catch
		select 'The Instructor ID already exists,Please choose another one'
		Select ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_LINE()
	end catch


----------update-----------
create proc Inst_Update @I_Number_old varchar(10),@I_Number_new varchar(10),@I_name_new varchar(50)
as
	begin try
		update dbo.Instructors
		SET inst_id=(case when @I_Number_new is not null then @I_Number_new else @I_Number_old end)
		,inst_name=(case when @I_name_new is not null then @I_name_new else inst_name end)
		where inst_id=@I_Number_old
	end try
	begin catch
		Select 'Faild to update Instructor ' +@I_Number_old
		Select ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_LINE()
	end catch


----------Delete-----------
create proc Inst_Delete @I_Number varchar(10)
as
	begin try
		delete from dbo.Instructors
		where inst_id=@I_Number
	end try
	begin catch
		Select 'Faild to update Instructor ' +@I_Number
		Select ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_LINE()
	end catch





-----------------------------------------------Topics-------------------------------------------------
------------------------------------------------------------------------------------------------------

----------Select-----------
Create proc ShowTopics @Tid varchar(10)
as
	Select * from Topics where topic_id = @Tid


----------Insert-----------
Create proc AddTopic @Tid varchar(10), @Tname varchar(50), @CourseID varchar(10)
as
	begin try
		insert into Topics
		values(@Tid, @Tname, @CourseID)
	end try
	begin catch
		Select 'Faild to insert into Topics'
		Select ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_LINE()
	end catch



----------update-----------
Create proc UpdateTopic @NewTid varchar(10), @Tid varchar(10),  @Tname varchar(50), @CourseID varchar(10)
as
	begin try
		Update Topics
		set topic_id = (case when @NewTid is not null then @NewTid else @Tid end),
			topic_name = (case when @Tname is not null then @Tname else topic_name end),
			crs_id = (case when @CourseID is not null then @CourseID else crs_id end)
		where topic_id = @Tid
	end try
	begin catch
		Select 'Faild to update topic ' + topic_id
		from Topics
		where topic_id = @Tid
		Select ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_LINE()
	end catch



----------delete-----------
Create proc DeleteTopic @Tid varchar(10)
as
	begin try
		Delete from Topics
		where topic_id = @Tid
	end try
	begin catch
		Select 'Faild to delete topic ' + topic_id
		from Topics
		where topic_id = @Tid
		Select ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_LINE()
	end catch








-----------------------------------------------Questions-------------------------------------------------
---------------------------------------------------------------------------------------------------------


----------Select-----------
Create proc ShowQuestions @QNo int
as
	Select * from Questions where q_no = @QNo



----------Insert-----------
Create proc AddQuestion @QNo int, 
	@QuesContent varchar(255), @TopID varchar(10)
as
	begin try
		insert into Questions
		values(@QNo, @QuesContent, @TopID)
	end try
	begin catch
		Select 'Faild to insert into Questions'
		Select ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_LINE()
	end catch



----------Update-----------
Create proc UpdateQuestion @NewQNo int, @QNo int, 
	@QuesContent varchar(255), @TopID varchar(10)
as
	begin try
		Update Questions
		set q_no = (case when @NewQNo is not null then @NewQNo else @QNo end),
			question = (case when @QuesContent is not null then @QuesContent else question end),
			topic_id = (case when @TopID is not null then @TopID else topic_id end)
		where q_no = @QNo
	end try
	begin catch
		Select 'Faild to update Question ' + q_no
		from Questions
		where q_no = @QNo
		Select ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_LINE()
	end catch



----------Delete-----------
Create proc DeleteQuestion @QNo int
as
	begin try
		Delete from Questions
		where q_no = @QNo
	end try
	begin catch
		Select 'Faild to delete Question ' + q_no
		from Questions
		where q_no = @QNo
		Select ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_LINE()
	end catch






-----------------------------------------------Questionss_Answers-------------------------------------------------
------------------------------------------------------------------------------------------------------------------



----------Select-----------
Create proc Select_From_QA (@q_no int = Null)
as
Begin
	if @q_no IS NULL
	Begin
		select * from Question_answers
	End
	else 
	Begin
		select * from Question_answers where q_no = @q_no
	End
End



----------Insert-----------
Create proc Insert_Into_QA (@qa_answer varchar(255) , @qa_letter varchar(1) , @qa_isTrue bit , @q_no int)
as
Begin
	Insert into Question_answers
	values (@qa_answer , @qa_letter , @qa_isTrue , @q_no)
End



----------Update-----------
alter proc Update_From_QA (@qa_id int , @q_no int , @qa_answer varchar(255) , @qa_isTrue bit  )
as
Begin
	if @qa_isTrue IS null
		Begin
			Update Question_answers
			set qa_answer = @qa_answer 
			where q_no = @q_no and qa_id = @qa_id
		End

	if @qa_answer IS NULL
		Begin
			Update Question_answers
			set qa_isTrue = @qa_isTrue 
			where q_no = @q_no and qa_id = @qa_id
		End

	else
		Begin
			Update Question_answers
			set qa_answer = @qa_answer  , qa_isTrue = @qa_isTrue
			where q_no = @q_no and qa_id = @qa_id
		End
End



----------Update-----------
Create proc Delete_From_QA (@q_no int = Null)
as
Begin
	Delete from Question_answers where q_no = @q_no
End




----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------