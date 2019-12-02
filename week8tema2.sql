create table Customer
(
	ID int primary key not null,
	[Name] nvarchar(50),
	Email nvarchar(50),
);

create table Employee
(
	ID int primary key not null,
	[Name] nvarchar(50),
	Email nvarchar(50),
);

create table Category
(
	ID int primary key not null,
	[Name] nvarchar(50),
	EmployeeID int not null foreign key references Employee(ID),
);


create table Product
(
	ID int primary key not null,
	[Name] nvarchar(50),
	CategoryID int not null foreign key references Category(ID),
	[Description] nvarchar(50),
	Price int,
);


create table [Order]
(
	ID int primary key not null,
	[Data] date,
	CustomerID int not null foreign key references Customer(ID),
	[Status] nvarchar(50),
	TotalPrice int,
);

create table OrderProduct
(	
	ProductID int not null foreign key references Product(ID),
	NumberOfProducts int,
	OrderID int not null foreign key references [Order](ID),
);

select (select Price from Product)+(select NumberOfProducts from OrderProduct) as TotalPrice; 


insert into dbo.Customer
values
		(1,'Client 1','client1@wantsome.com'),
		(2,'Client 2','client2@wantsome.com'),
		(3,'Client 3','client3@wantsome.com'),
		(4,'Client 4','client4@gmail.com');

insert into Employee
values
		(1,'Angajat 1','Angajat1@wantsome.com'),
		(2,'Angajat 2','Angajat2@wantsome.com'),
		(3,'Angajat 3','Angajat3@wantsome.com'),
		(4,'Angajat 4','Angajat4@gmail.com');

insert into Category
values
		(1,'Categorie 1',1),
		(2,'Categorie 2',1),
		(3,'Categorie 3',1),
		(4,'Categorie 4',2),
		(5,'Categorie 5',2),
		(6,'Categorie 6',3),
		(7,'Categorie 7',4);

insert into Product
values
		(1,'Produs 1',1,'descriere 1',10),
		(2,'Produs 2',1,'descriere 2',15),
		(3,'Produs 3',2,'descriere 3',19),
		(4,'Produs 4',2,'descriere 4',20),
		(5,'Produs 5',3,'descriere 5',30),
		(6,'Produs 6',4,'descriere 6',20),
		(7,'Produs 7',5,'descriere 7',10),
		(8,'Produs 8',6,'descriere 8',25),
		(9,'Produs 9',7,'descriere 9',30);

insert into [Order]
values
		(1,'2019-05-10',1,'aproveed'),
		(2,'2019-07-11',2,'aproveed'),
		(3,'2019-05-10',3,'aproveed');

insert into OrderProduct
values
		(1,2,1),
		(2,3,2),
		(3,3,3);


--4
select * from Product


--5
select * from Customer
where Eamil like '%wantsome.com%'



--6
select [CategoryID],sum([Price]) as TotalPrice
from [Product]
group by [CategoryID];		



--7
select [Name],(select count(*) from [Order] where Customer.ID=[Order].CustomerID) as Nr
from Customer
where  (select count(*) from [Order] where Customer.ID=[Order].CustomerID)>10
order by Nr desc


--8
select * from Customer
left join [Order]
on Customer.ID=[Order].CustomerID
left join OrderProduct
on OrderProduct.OrderID=[Order].ID
order by ProductID



--9a
select * from Customer
left join [Order]
on Customer.ID=[Order].CustomerID
where [Data]>'2018-12-31' and [Data]<='2019-03-31'


--9b
select * from Customer
left join [Order]
on Customer.ID=[Order].CustomerID

left join OrderProduct
on OrderProduct.OrderID=[Order].ID
left join Product
on Product.ID=OrderProduct.ProductID
where CategoryID=1
order by ProductID


--10
CREATE PROCEDURE ModifyStatus @Status nvarchar(50),@IDOrder int
AS
BEGIN
SET NOCOUNT ON
 update [Order]
 set [Status]=@Status,
 [Data]=GETDATE()
 where ID=@IDOrder
END




--11
select [ProductID],sum([NumberOfProducts]) as TotalOrders
from OrderProduct
group by [ProductID];


--12 nu merge deoarece sunt mai multe produse pe un order si nu stiu cum sa iau pretul pentru fiecare in parte
create function CalculateTotalPrice(@IDorder int)
returns int 
as
begin 
declare @Aux int
declare @Price int
declare @Nr int
set @Nr=(select sum(OrderProduct.NumberOfProducts) from OrderProduct where OrderID=@IDorder)

set @Aux= select OrderProduct.ProductID from OrderProduct where OrderID=@IDorder

return
(
	@Aux*@Nr
)
end



