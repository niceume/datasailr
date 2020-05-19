sail = function( df , code , fullData = TRUE , rowname = "_rowname_" , stringsAsFactors = FALSE ){
	colnames_df = colnames(df)
	rowname_added_temporarily = F

	if( rowname == F ){
	}else{
		rowname_within_ori_df = ( rowname %in% colnames_df )
		if( ! rowname_within_ori_df ){
			if( !is.null(nrow(df)) && ( nrow(df) == length(row.names(df)))){
				df[,rowname] = row.names(df)
				rowname_added_temporarily = T
			}else{
				cat("NOTE: `nrow(df)` returns inappropriate size: " , ifelse( is.null(nrow(df)), "NULL" , nrow(df) ) , "\n" , sep="" )
				cat("NOTE: rowname parameter is ignored. \n")
				# rowname needs not be added as a new column
			}
		}else{
			# rowname needs not be added as a new column
		}
	}

	result = .data_sailr_cpp_execute( code, df)

	if(stringsAsFactors == TRUE ){
		result_df = data.frame( lapply(result, function(x) if (is.factor(x)) as.character(x) else {x} ), stringsAsFactors = TRUE )  # Deal strings as factors
	}else{
		result_df = result # Deal strings as chracter vectors (Default action)
	}

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
