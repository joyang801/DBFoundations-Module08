--*************************************************************************--
-- Title: Assignment08
-- Author: QiaoyiYang
-- Desc: This file demonstrates how to use Stored Procedures
-- Change Log: When,Who,What
-- 2017-01-01,QiaoyiYang,Created File
--**************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment08DB_QiaoyiYang')
	 Begin 
	  Alter Database [Assignment08DB_QiaoyiYang] set Single_user With Rollback Immediate;
	  Drop Database Assignment08DB_QiaoyiYang;
	 End
	Create Database Assignment08DB_QiaoyiYang;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment08DB_QiaoyiYang;

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [money] NOT NULL
);
go

Create Table Employees -- New Table
([EmployeeID] [int] IDENTITY(1,1) NOT NULL 
,[EmployeeFirstName] [nvarchar](100) NOT NULL
,[EmployeeLastName] [nvarchar](100) NOT NULL 
,[ManagerID] [int] NULL  
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[EmployeeID] [int] NOT NULL -- New Column
,[ProductID] [int] NOT NULL
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Begin  -- Categories
	Alter Table Categories 
	 Add Constraint pkCategories 
	  Primary Key (CategoryId);

	Alter Table Categories 
	 Add Constraint ukCategories 
	  Unique (CategoryName);
End
go 

Begin -- Products
	Alter Table Products 
	 Add Constraint pkProducts 
	  Primary Key (ProductId);

	Alter Table Products 
	 Add Constraint ukProducts 
	  Unique (ProductName);

	Alter Table Products 
	 Add Constraint fkProductsToCategories 
	  Foreign Key (CategoryId) References Categories(CategoryId);

	Alter Table Products 
	 Add Constraint ckProductUnitPriceZeroOrHigher 
	  Check (UnitPrice >= 0);
End
go

Begin -- Employees
	Alter Table Employees
	 Add Constraint pkEmployees 
	  Primary Key (EmployeeId);

	Alter Table Employees 
	 Add Constraint fkEmployeesToEmployeesManager 
	  Foreign Key (ManagerId) References Employees(EmployeeId);
End
go

Begin -- Inventories
	Alter Table Inventories 
	 Add Constraint pkInventories 
	  Primary Key (InventoryId);

	Alter Table Inventories
	 Add Constraint dfInventoryDate
	  Default GetDate() For InventoryDate;

	Alter Table Inventories
	 Add Constraint fkInventoriesToProducts
	  Foreign Key (ProductId) References Products(ProductId);

	Alter Table Inventories 
	 Add Constraint ckInventoryCountZeroOrHigher 
	  Check ([Count] >= 0);

	Alter Table Inventories
	 Add Constraint fkInventoriesToEmployees
	  Foreign Key (EmployeeId) References Employees(EmployeeId);
End 
go

-- Adding Data (Module 04) -- 
-- NOTE: We are starting without data this time!

-- Adding Views (Module 06) -- 
Create View vCategories With SchemaBinding
 AS
  Select CategoryID, CategoryName From dbo.Categories;
go
Create View vProducts With SchemaBinding
 AS
  Select ProductID, ProductName, CategoryID, UnitPrice From dbo.Products;
go
Create View vEmployees With SchemaBinding
 AS
  Select EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID From dbo.Employees;
go
Create View vInventories With SchemaBinding 
 AS
  Select InventoryID, InventoryDate, EmployeeID, ProductID, [Count] From dbo.Inventories;
go

/********************************* Questions and Answers *********************************/
/* NOTE:Use the following template to create your stored procedures and plan on this taking ~2-3 hours

Create Procedure <pTrnTableName>
 (<@P1 int = 0>)
 -- Author: QiaoyiYang
 -- Desc: Processes <Desc text>
 -- Change Log: When,Who,What
 -- 2021-12-01,QiaoyiYang,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	-- Transaction Code --
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go
*/

-- Question 1 (20 pts): How can you create Insert, Update, and Delete Transactions Store Procedures  
-- for the Categories table?
--Create Procedure pInsCategories
--< Place Your Code Here!>--
Create Procedure pInsCategories
 (@CategoryName nvarchar (100))
 -- Author: QiaoyiYang
 -- Desc: Processes Inserts for Categories
 -- Change Log: When,Who,What
 -- 2021-12-01,QiaoyiYang,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Insert into Categories (CategoryName) values (@CategoryName);
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

--Create Procedure pUpdCategories
--< Place Your Code Here!>--
Create Procedure pUpdCategories
 (@CategoryID int, @CategoryName nvarchar (100))
 -- Author: QiaoyiYang
 -- Desc: Processes Updates for Categories
 -- Change Log: When,Who,What
 -- 2021-12-01,QiaoyiYang,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Update Categories 
		Set CategoryName = @CategoryName
		Where CategoryID = @CategoryID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

--Create Procedure pDelCategories
--< Place Your Code Here!>--
Create Procedure pDelCategories
  (@CategoryID int)
 -- Author: QiaoyiYang
 -- Desc: Processes Deletes for Categories
 -- Change Log: When,Who,What
 -- 2021-12-01,QiaoyiYang,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Delete From Categories
		Where CategoryID = @CategoryID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

-- Question 2 (20 pts): How can you create Insert, Update, and Delete Transactions Store Procedures  
-- for the Products table?
--Create Procedure pInsProducts
--< Place Your Code Here!>--
Create Procedure pInsProducts
 (@ProductName nvarchar (100), @CategoryID int, @UnitPrice money )
 -- Author: QiaoyiYang
 -- Desc: Processes Inserts for Products
 -- Change Log: When,Who,What
 -- 2021-12-01,QiaoyiYang,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Insert into Products (ProductName, CategoryID, UnitPrice) values (@ProductName, @CategoryID, @UnitPrice)
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

--Create Procedure pUpdProducts
--< Place Your Code Here!>--
Create Procedure pUpdProducts
 (@ProductID int, @ProductName nvarchar (100), @CategoryID int, @UnitPrice money)
 -- Author: QiaoyiYang
 -- Desc: Processes Updates for Products
 -- Change Log: When,Who,What
 -- 2021-12-01,QiaoyiYang,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Update Products 
		Set ProductName = @ProductName,
        CategoryID = @CategoryID,
        UnitPrice = @UnitPrice
		Where ProductID = @ProductID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

--Create Procedure pDelProducts
--< Place Your Code Here!>--
Create Procedure pDelProducts
(@ProductID int)
 -- Author: QiaoyiYang
 -- Desc: Processes Deletes for Products
 -- Change Log: When,Who,What
 -- 2021-12-01,QiaoyiYang,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Delete From Products
		Where ProductID = @ProductID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go


-- Question 3 (20 pts): How can you create Insert, Update, and Delete Transactions Store Procedures  
-- for the Employees table?
--Create Procedure pInsEmployees
--< Place Your Code Here!>--
Create Procedure pInsEmployees
 (@EmployeeFirstName nvarchar (100), @EmployeeLastName nvarchar (100), @ManagerID int)
 -- Author: QiaoyiYang
 -- Desc: Processes Inserts for Employees
 -- Change Log: When,Who,What
 -- 2021-12-01,QiaoyiYang,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Insert into Employees (EmployeeFirstName, EmployeeLastName, ManagerID) values (@EmployeeFirstName, @EmployeeLastName, @ManagerID)
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

--Create Procedure pUpdEmployees
--< Place Your Code Here!>--
Create Procedure pUpdEmployees
 (@EmployeeID int, @EmployeeFirstName nvarchar (100), @EmployeeLastName nvarchar (100), @ManagerID int)
 -- Author: QiaoyiYang
 -- Desc: Processes <Desc text>
 -- Change Log: When,Who,What
 -- 2021-12-01,QiaoyiYang,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	-- Transaction Code --
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

--Create Procedure pDelEmployees
--< Place Your Code Here!>--
Create Procedure pDelEmployees
(@EmployeeID int)
 -- Author: QiaoyiYang
 -- Desc: Processes Deletes for Products
 -- Change Log: When,Who,What
 -- 2021-12-01,QiaoyiYang,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Delete From Employees
		Where EmployeeID = @EmployeeID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

-- Question 4 (20 pts): How can you create Insert, Update, and Delete Transactions Store Procedures  
-- for the Inventories table?
--Create Procedure pInsInventories
--< Place Your Code Here!>--
Create Procedure pInsInventories
 (@InventoryDate date, @EmployeeID int, @ProductID int, @Count int)
 -- Author: QiaoyiYang
 -- Desc: Processes Inserts for Inventories
 -- Change Log: When,Who,What
 -- 2021-12-01,QiaoyiYang,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Insert into Inventories (InventoryDate, EmployeeID, ProductID, Count) values (@InventoryDate, @EmployeeID, @ProductID, @Count)
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

--Create Procedure pUpdInventories
--< Place Your Code Here!>--
Create Procedure pUpdInventories
(@InventoryID int,  @InventoryDate date, @EmployeeID int, @ProductID int, @Count int)
 -- Author: QiaoyiYang
 -- Desc: Processes <Desc text>
 -- Change Log: When,Who,What
 -- 2021-12-01,QiaoyiYang,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	-- Transaction Code --
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

--Create Procedure pDelInventories
--< Place Your Code Here!>--
Create Procedure pDelInventories
(@InventoryID int)
 -- Author: QiaoyiYang
 -- Desc: Processes Deletes for Inventories
 -- Change Log: When,Who,What
 -- 2021-12-01,QiaoyiYang,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Delete From Inventories
		Where InventoryID = @InventoryID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go
-- Question 5 (20 pts): How can you Execute each of your Insert, Update, and Delete stored procedures? 
-- Include custom messages to indicate the status of each sproc's execution.

-- Here is template to help you get started:
/*
Declare @Status int;
Exec @Status = <SprocName>
                @ParameterName = 'A'
Select Case @Status
  When +1 Then '<TableName> Insert was successful!'
  When -1 Then '<TableName> Insert failed! Common Issues: Duplicate Data'
  End as [Status];
Select * From <ViewName> Where ColID = 1;
go
*/


--< Test Insert Sprocs >--
-- Test [dbo].[pInsCategories]
Declare @Status int;
Exec @Status = pInsCategories 
		@CategoryName = 'A';
Select Case @Status
  When +1 Then 'Categories Insert was successful!'
  When -1 Then 'Categories Insert failed! Common Issues: Foreign Key Violation'
  End as [Status]; -- Will be Null unless we add a Return Code to this Sproc!
Select * From Categories  Where CategoryID = @@IDENTITY;
go


-- Test [dbo].[pInsProducts]
Declare @Status int;
Exec @Status = pInsProducts 
		@ProductName = 'AA',
    @CategoryID = @@IDENTITY,
		@UnitPrice = 12.00
Select Case @Status
  When +1 Then 'Products Insert was successful!'
  When -1 Then 'Products Insert failed! Common Issues: Foreign Key Violation'
  End as [Status]; -- Will be Null unless we add a Return Code to this Sproc!
Select * From Products  Where ProductID = @@IDENTITY;
go


-- Test [dbo].[pInsEmployees]
Declare @Status int;
Exec @Status = pInsEmployees 
		@EmployeeFirstName = 'Devon',
    @EmployeeLastName = 'Qin',
    @ManagerID = @@IDENTITY
Select Case @Status
  When +1 Then 'Employees Insert was successful!'
  When -1 Then 'Employees Insert failed! Common Issues: Foreign Key Violation'
  End as [Status]; -- Will be Null unless we add a Return Code to this Sproc!
Select * From Employees  Where EmployeeID = @@IDENTITY;
go

-- Test [dbo].[pInsInventories]
Declare @Status int;
Exec @Status = pInsInventories 
		@InventoryDate = '20211205',
    @EmployeeID = @@IDENTITY,
    @ProductID = @@IDENTITY,
		@Count = @@IDENTITY
Select Case @Status
  When +1 Then 'Inventories  Insert was successful!'
  When -1 Then 'Inventories  Insert failed! Common Issues: Foreign Key Violation'
  End as [Status]; -- Will be Null unless we add a Return Code to this Sproc!
Select * From Inventories  Where InventoryID = @@IDENTITY;
go


--< Test Update Sprocs >--
-- Test Update [dbo].[pUpdCategories]
Declare @Status int;
Exec @Status = pUpdCategories
             @CategoryID = 1,
 	         @CategoryName = 'B';
Select Case @Status
  When +1 Then 'Categories Update was successful!'
  When -1 Then 'Categories Update failed! Common Issues: Foreign Key Violation'
  End as [Status]; -- Will be Null unless we add a Return Code to this Sproc!
Select * From Categories Where CategoryID = @@IDENTITY;
go


-- Test [dbo].[pUpdProducts]
Declare @Status int;
Exec @Status = pUpdProducts
             @ProductID = 1,
 			      @ProductName = 'BB',
             @CategoryID = @@IDENTITY,
             @UnitPrice = 16.00;
Select Case @Status
  When +1 Then 'Products Update was successful!'
  When -1 Then 'Products Update failed! Common Issues: Foreign Key Violation'
  End as [Status]; -- Will be Null unless we add a Return Code to this Sproc!
Select * From Products  Where ProductID = @@IDENTITY;
go

-- Test [dbo].[pUpdEmployees]
Declare @Status int;
Exec @Status = pUpdEmployees
             @EmployeeID = 1,
 			      @EmployeeFirstName = 'Dehao',
             @EmployeeLastName = 'Qin',
             @ManagerID = @@IDENTITY;
Select Case @Status
  When +1 Then 'Employees Update was successful!'
  When -1 Then 'Employees Update failed! Common Issues: Foreign Key Violation'
  End as [Status]; -- Will be Null unless we add a Return Code to this Sproc!
Select * From Employees  Where EmployeeID = @@IDENTITY;
go

-- Test [dbo].[pUpdInventories]
Declare @Status int;
Exec @Status = pUpdInventories
             @InventoryID = 1,
 			      @InventoryDate = '20211206',
             @EmployeeID = @@IDENTITY,
             @ProductID = @@IDENTITY,
             @Count = @@IDENTITY;
Select Case @Status
  When +1 Then 'Inventories Update was successful!'
  When -1 Then 'Inventories Update failed! Common Issues: Foreign Key Violation'
  End as [Status]; -- Will be Null unless we add a Return Code to this Sproc!
Select * From Inventories  Where InventoryID = @@IDENTITY;
go

--< Test Delete Sprocs >--
-- Test [dbo].[pDelInventories]
Declare @Status int;
Exec @Status = pDelInventories
                @InventoryID = @@IDENTITY 
Select Case @Status
  When +1 Then 'Inventories Delete was successful!'
  When -1 Then 'Inventories Delete failed! Common Issues: Foreign Key Violation'
  End as [Status]; -- Will be Null unless we add a Return Code to this Sproc!
Select * From Inventories Where InventoryID = @@IDENTITY;
go


--< Test Delete Sprocs >--
-- Test [dbo].[pDelEmployees]
Declare @Status int;
Exec @Status = pDelEmployees
                @EmployeeID = @@IDENTITY 
Select Case @Status
  When +1 Then 'Employees Delete was successful!'
  When -1 Then 'Employees Delete failed! Common Issues: Foreign Key Violation'
  End as [Status]; -- Will be Null unless we add a Return Code to this Sproc!
Select * From Employees Where EmployeeID = @@IDENTITY;
go

-- Test [dbo].[pDelProducts]
Declare @Status int;
Exec @Status = pDelProducts
                @ProductID = @@IDENTITY 
Select Case @Status
  When +1 Then 'Products Delete was successful!'
  When -1 Then 'Products Delete failed! Common Issues: Foreign Key Violation'
  End as [Status]; -- Will be Null unless we add a Return Code to this Sproc!
Select * From Products Where ProductID = @@IDENTITY;
go

-- Test [dbo].[pDelCategories]
Declare @Status int;
Exec @Status = pDelCategories
                @CategoryID = @@IDENTITY 
Select Case @Status
  When +1 Then 'Categories Delete was successful!'
  When -1 Then 'Categories Delete failed! Common Issues: Foreign Key Violation'
  End as [Status]; -- Will be Null unless we add a Return Code to this Sproc!
Select * From Categories Where CategoryID = @@IDENTITY;
go


--{ IMPORTANT!!! }--
-- To get full credit, your script must run without having to highlight individual statements!!!  

/***************************************************************************************/