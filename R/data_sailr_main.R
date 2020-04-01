sail = function( df , code , fullData = TRUE ,  rowname = "_rowname_" ){
	colnames_df = colnames(df)
	rowname_added_temporarily = F

	if( rowname == F ){
	}else{
		rowname_within_ori_df = ( rowname %in% colnames_df )
		if( ! rowname_within_ori_df ){
			df[,rowname] = row.names(df)
			rowname_added_temporarily = T
		}else{
			# need not be added
		}
	}

	result = .data_sailr_cpp_execute( code, df)
	result_df = data.frame( result , stringsAsFactors = F )

	if( rowname_added_temporarily  ){
		df = df[ , !( colnames(df) %in%  rowname )]
	}

	if(fullData == T){
		result_df = cbind( df , result_df )
	}

	return(result_df)
}


author = function(){
  print("DataSailr is actively developed by Toshi Umehara (@niceume).")
}
