use BloodBankManagementSystems;

select * from location;
select * from donor_health;
-- donors who weigh between 60kgs to 70 kgs
select distinct d.DonorName, dh.DonorWeight  from donor as d
inner join donor_health as dh
on d.DonorID=dh.DonorID
inner join stemcelldonation as sd
on dh.DonorID=dh.DonorID
where DonorWeight between 60 and 70;

-- Plasma donor who live in California
Select d.DonorName, l.City
from donor as d
inner join plasmadonation as pd
on d.DonorID=pd.DonorID
inner join location as l
on  pd.LocationID= l.LocationID
where city = 'Pittsburgh';

drop table bloodneeded;
CREATE TABLE bloodneeded (
 bloodneededID INT UNSIGNED NOT NULL AUTO_INCREMENT,
 Treatment_type VARCHAR(20) NOT NULL,
 Donors_needed INT NOT NULL,
  PRIMARY KEY (bloodneededID));
insert into bloodneeded
Values (1,'Heart Surgery', 5),
 (2,'Car Crash', 50),
(3,'Cancer Treatment', 5),
(4,'Leukmia', 8);

select * from recipient;
-- To get feedback from male donors
select FeedbackID, Feedback_Comments
from feedback as f
inner join recipient as r
on f.RecipientID= r.RecipientID
where RecipientGender= 'M';

-- To find average donation quantity for each state
select  avg(AvailableQuantity),state from location
group by state;


-- Find out how many stem cell donors are there in each city
select count(d.DonorID), l.city from donor d
inner join location l
on d.LocationID=l.LocationID
inner join plasmadonation pd
on d.DonorID= pd.DonorID
group by l.city;

-- Find out how many plasma donors are there in each state
select count(d.DonorID), l.city from donor d
inner join location l
on d.LocationID=l.LocationID
inner join stemcelldonation sd
on d.DonorID= sd.DonorID
group by l.state;

-- List all the blood quantity and type by Location
select r.NoofBags,r.BloodGroup from bloodinventory bi
inner join request r
on r.LocationID= bi.LocationID ;

-- Give the list of donors for locations which have more than 4 quantities of blood requested\
select DonorName 
from donor d
 inner join request r
 on d.LocationID=r.LocationID
 where NoofBags> 4;

-- get the donor details whose donation quantity is > 5
select * from donor 
where DonationQuantity>5;


-- Procedure 
DELIMITER //
CREATE PROCEDURE quantity5()
BEGIN
SELECT * FROM donor 
WHERE DonationQuantity>5;
END // 

call quantity5;

DELIMITER //
CREATE PROCEDURE donordetails()
BEGIN
select * from donor;
END // 
-- Availability of item in each bloodbank 
DELIMITER //
CREATE Function getinventorystatus(numBags INT)
Returns VARCHAR(12)
BEGIN
	Declare status VARCHAR(12);
    select InventoryStatus into status
    from bloodinventory
    where NumberOfBags>= numBags;
    Return status;
END //
-- For a given hospital (specified by HospID), can you provide a report that shows the total blood 
-- quantity (in bags) available in each blood group (BloodGroup) at the hospital's location? 
select * from location;
select NumberOfBags, BloodGroup, HospID, LocationName
from hospital_details hd
inner join bloodinventory bi on hd.LocationID=bi.LocationID
inner join location l on bi.LocationID=l.LocationID
where  LocationName ='Santa';

-- Male recipient feedback 
select * from Recipient;
select Feedback_Comments,FeedbackID from Feedback as f
join Recipient as r
on r.RecipientID= f.RecipientID
where r.RecipientGender= 'M';


-- Assigning a BLOOD BADGE to a donor based on the quantity of blood donated overtime

select * from PlasmaDonation
select * from StemCellDonation

DELIMITER //

CREATE FUNCTION badge(quantity INT)
RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
    DECLARE badge VARCHAR(30);

    CASE
        WHEN quantity = 1 THEN SET badge = 'Bronze';
        WHEN quantity > 1 AND quantity <= 2 THEN SET badge = 'Silver';
        WHEN quantity > 2 AND quantity <= 3 THEN SET badge = 'Gold';
        WHEN quantity > 3 THEN SET badge = 'Platinum';
    END CASE;

    RETURN badge;
END //

DELIMITER ;

select count(DonorName) as NumofDonors, badge(DonationQuantity) as badges from Donor
group by badges
order by NumofDonors desc ;

-- Gives the total salary of every employee
select * from accounts;
drop function totalsalary;
DELIMITER //

CREATE FUNCTION totalsalary(EmplyID INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE totalSalary INT;

    SELECT (BasePay + Incentive) INTO totalSalary FROM Accounts
    where EmplyID= EmpID;

    RETURN totalSalary;
END //

DELIMITER ;

select EmpID, totalSalary(EmpID) as salary from Accounts;

select * from BloodInventory;
drop function bloodavailability;
DELIMITER //

CREATE FUNCTION bloodavailability(status VARCHAR(30))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE availabilityStatus VARCHAR(30);

    CASE
        WHEN status = 'Available' THEN SET availabilityStatus = 'Blood bag available';
        WHEN status = 'Unavailable' THEN SET availabilityStatus = 'Blood bag unavailable';
    END CASE;

    RETURN availabilityStatus;
END //

DELIMITER ;

select bloodavailability(InventoryStatus) from BloodInventory;

-- Procedure: Fetches the Donor details according to the Donor ID.
DELIMITER //
create procedure donordetails(id int)
as 
begin
select * from donor where DonorID=id
end//

DELIMITER //

CREATE PROCEDURE donordetails(IN id INT)
BEGIN
    SELECT * FROM Donor WHERE DonorID = id;
END //

DELIMITER ;
select * from Donor;
call donordetails (111111);

DELIMITER //

CREATE PROCEDURE empdetails()
BEGIN
    SELECT * FROM Employee;
END //

DELIMITER ;

select * from Employee;
call empdetails ();