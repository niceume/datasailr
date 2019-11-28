sail = function( df , code , fullData = FALSE){
	colnames_df = colnames(df)
	if( "_rowname_" %in% colnames_df){
		# Need to add _rowname_ column
	}else{
		df[,"_rowname_"] = row.names(df)
	}

	result_df = data.frame( .data_sailr_cpp_execute( code, df) )
	if(fullData == T){
		result_df = cbind( df , result_df , stringsAsFactors = FALSE)
	}else{
		
	}
	return(result_df)
}


author = function(){
  print("dataSailr is actively developed by Toshi Umehara (@niceume).")
}
