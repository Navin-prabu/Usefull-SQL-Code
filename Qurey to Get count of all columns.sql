
-- Check NULL VAlue Counts

	-- Create Table to Store Results

		Truncate table Sf.SFP_7607_Case_Column_Count;

		Insert into Sf.SFP_7607_Case_Column_Count
		Select 
			Column_Name,
			ORDINAL_POSITION,
			Cast(NULL as varchar(50)) as _Count 
			--INTO Sf.SFP_7607_Case_Column_Count
		from 
			information_schema.columns 
		where 
			table_name = 'SFP_7607_Case_Fix';

	-- Store PRoc to update Sf.SFP_7607_Case_Column_Count
	
	Declare

	 @InsertString nVarchar(4000),
	 @Column_Name nVarchar(4000);

	 WHILE 	
		1 <	(Select count(1) from Sf.SFP_7607_Case_Column_Count where _Count is null)
	Begin
		
		Set @Column_Name =  (Select top 1 Column_Name From Sf.SFP_7607_Case_Column_Count where _Count is null);

		Set @InsertString = (
		Select 
		'
		update Sf.SFP_7607_Case_Column_Count set _Count = (Select count(1) from Sf.SFP_7607_Case_Fix where '+@Column_Name+ ' is not null) 
		where
		Column_Name =' +''''+ @Column_Name+''''
		);

		EXECUTE sp_executesql @InsertString 
	END
