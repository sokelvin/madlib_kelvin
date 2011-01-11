/*
	This code computes quantile value from a table;
	table_name - is the name of the table from which quantile is to be taken
	col_name - is the name of the column that is to be used for quantile culculation
	quantile - is the qunatile value desired \in (0,1)
	
	Example:
		SELECT quantile(MyTaxEvasionRecords, AnountUnderpaid, .3);
*/

DROP FUNCTION IF EXISTS quantile(table_name TEXT, col_name TEXT, quantile FLOAT);
    	RAISE INFO 'VALUES NOW: % WANT: % FRACT: % MIN: % MAX: % CURR: %', curr, size[1], curr/size[1] + size[1]/curr, size[2], size[3], size[4];