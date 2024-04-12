global class KadantReportClasses {
    
    @AuraEnabled
    public static List<List<String>> RunMatrixReport1D1A(Id reportId, String GrpAcross, String GrpAcrossDim, String GrpDown, String GrpDownDate, String ZFil1key, String ZFil1val, String ZFil2key, String ZFil2val, String ZFil3key, String ZFil3val, String SFil1key, String SFil1val, String SFil2key, String SFil2val, String DFilValFrom, String DFilValTo) {
        
        //---------------------------------------------------------------------
        //--------------------- initialize empty meta data set ----------------
        //---------------------------------------------------------------------
        Reports.ReportMetadata meta = new Reports.ReportMetadata(); 
        

        //---------------------------------------------------------------------
        //---------------------- apply report filters -------------------------
        //---------------------------------------------------------------------
		Reports.ReportFilter[] filList = new Reports.ReportFilter[]{};
        Reports.ReportFilter rf = new Reports.ReportFilter();
            
        if(ZFil1key<>''){
    		rf = new Reports.ReportFilter(ZFil1key,'equals',ZFil1val.replace('N/A',''));
    		filList.add(rf);
        }
        
		if(ZFil2key<>''){
            rf = new Reports.ReportFilter(ZFil2key,'equals',ZFil2val.replace('N/A',''));
    		filList.add(rf);
        }

        if(ZFil3key<>''){
    		rf = new Reports.ReportFilter(ZFil3key,'equals',ZFil3val.replace('N/A',''));
   			filList.add(rf);
        }
        
        if(SFil1key<>''){
    		rf = new Reports.ReportFilter(SFil1key,'equals',SFil1val);
    		filList.add(rf);
        }
        
		if(SFil2key<>''){
            rf = new Reports.ReportFilter(SFil2key,'equals',SFil2val);
    		filList.add(rf);
        }

        meta.setReportFilters(filList);
		//meta.setReportBooleanFilter(booleanFilter); 
        
        
        //-----------------------------------------------------------------------
        //------------------- apply standard date filter ------------------------
        //-----------------------------------------------------------------------
        Reports.standardDateFilter stdDateFilter = new Reports.StandardDateFilter();
        stdDateFilter.setColumn(GrpAcross);
        stdDateFilter.setStartDate(DFilValFrom);
        stdDateFilter.setEndDate(DFilValTo);
        stdDateFilter.setDurationValue('CUSTOM');
        meta.setStandardDateFilter(stdDateFilter);
        
        
        //-----------------------------------------------------------------------
        //------------------ apply general report info --------------------------
        ////---------------------------------------------------------------------
        
		meta.setHasRecordCount(true); 
		//meta.setAggregates(new List<String>{'s!Account.Credit_Limit__c.CONVERT','RowCount'}); 
        meta.setAggregates(new List<String>{'s!ORDER_ITEM_TOTALPRICE.CONVERT','RowCount'});

        
        //---------------------------------------------------------------------
        //---------------------- apply grouping down -------------------------
        //---------------------------------------------------------------------
        Reports.GroupingInfo gi = new Reports.GroupingInfo();
     
        Integer GroupDownIsDate = 0;
		if(GrpDown=='FISCAL_PERIOD'){gi.setName(GrpDownDate); GroupDownIsDate = 1; gi.setDateGranularity(Reports.DateGranularity.FISCAL_PERIOD);}
        if(GrpDown=='FISCAL_QUARTER'){gi.setName(GrpDownDate); GroupDownIsDate = 1; gi.setDateGranularity(Reports.DateGranularity.FISCAL_QUARTER);}
        if(GrpDown=='FISCAL_WEEK'){gi.setName(GrpDownDate); GroupDownIsDate = 1; gi.setDateGranularity(Reports.DateGranularity.FISCAL_WEEK);}
        if(GrpDown=='MONTH'){gi.setName(GrpDownDate); GroupDownIsDate = 1; gi.setDateGranularity(Reports.DateGranularity.MONTH);}
        if(GrpDown=='QUARTER'){gi.setName(GrpDownDate); GroupDownIsDate = 1; gi.setDateGranularity(Reports.DateGranularity.QUARTER);}
        if(GrpDown=='WEEK'){gi.setName(GrpDownDate); GroupDownIsDate = 1; gi.setDateGranularity(Reports.DateGranularity.WEEK);}
        
        if(GroupDownIsDate == 0){
            gi.setName(GrpDown);			
			gi.setDateGranularity(Reports.DateGranularity.NONE);    
        }
		gi.setsortOrder(Reports.ColumnSortOrder.ASCENDING);
        
        List<Reports.GroupingInfo> gil = new List<Reports.groupinginfo>(); 
		gil.add(gi); 
		meta.setGroupingsDown(gil); 
		meta.setHasDetailRows(true); 
        
        
        //---------------------------------------------------------------------
        //--------------------- apply grouping across -------------------------
        //---------------------------------------------------------------------
            
        Reports.GroupingInfo gi2 = new Reports.GroupingInfo(); 
        
        gi2.setName(GrpAcross); 
		gi2.setsortOrder(Reports.ColumnSortOrder.ASCENDING); 
        if(GrpAcrossDim=='NONE'){gi2.setDateGranularity(Reports.DateGranularity.NONE);}
		if(GrpAcrossDim=='FISCAL_PERIOD'){gi2.setDateGranularity(Reports.DateGranularity.FISCAL_PERIOD);}
        if(GrpAcrossDim=='FISCAL_YEAR'){gi2.setDateGranularity(Reports.DateGranularity.FISCAL_YEAR);}
        if(GrpAcrossDim=='FISCAL_QUARTER'){gi2.setDateGranularity(Reports.DateGranularity.FISCAL_QUARTER);}
        if(GrpAcrossDim=='FISCAL_WEEK'){gi2.setDateGranularity(Reports.DateGranularity.FISCAL_WEEK);}
        if(GrpAcrossDim=='MONTH'){gi2.setDateGranularity(Reports.DateGranularity.MONTH);}
        if(GrpAcrossDim=='YEAR'){gi2.setDateGranularity(Reports.DateGranularity.YEAR);}
        if(GrpAcrossDim=='QUARTER'){gi2.setDateGranularity(Reports.DateGranularity.QUARTER);}
        if(GrpAcrossDim=='WEEK'){gi2.setDateGranularity(Reports.DateGranularity.WEEK);}
		
        List<Reports.GroupingInfo> gil2 = new List<Reports.groupinginfo>(); 
		gil2.add(gi2); 
		meta.setGroupingsAcross(gil2); 
		meta.setHasDetailRows(true);

        
        //---------------------------------------------------------------------
        //------------------- define report details columns -------------------
        //---------------------------------------------------------------------
        
        //meta.setDetailColumns(new List<String>{'Account.Credit_Limit__c.CONVERT','USERS.NAME','ACCOUNT.NAME','DUE_DATE','ADDRESS1_STATE'}); 
		meta.setDetailColumns(new List<String>{'ORDER_ITEM_TOTALPRICE.CONVERT','ORDER_NUMBER','ORDER_STATUS','ORDER_TYPE','ORDER_TOTAL_AMOUNT','ORDER_CREATED_DATE','ACCOUNT_NAME','ORDER_ITEM_ID','ORDER_ITEM_NAME','ORDER_ITEM_CUSTOMER_PROD_ID','ORDER_ITEM_UNITPRICE','ORDER_ITEM_QUANTITY','ORDER_ITEM_LISTPRICE'}); 
        
        
        //----------------------------------------------------------------------
        //-------------- run the report with predefined meta data --------------
        //----------------------------------------------------------------------
        
        Reports.ReportResults results = Reports.ReportManager.runReport(reportId, meta, true);
        //Reports.ReportManager.runAsyncReport(reportId, meta, true); 
		//Reports.ReportResults results = Reports.ReportManager.runReport(reportId, true);

        
        //---------------------------------------------------------------------
		//--------------- get the metadata of the executed report -------------
		//---------------------------------------------------------------------
		
		Reports.ReportMetadata reportMetadata = results.getReportMetadata();

        system.debug(reportMetadata);
            
		//find out what type of report it is by looking at the groupings down and groupings across
		Integer groupingsDown = 0;
		Integer groupingsAcross = 0;

		List<Reports.GroupingInfo> groupingDownList = reportMetadata.getGroupingsDown();
		List<Reports.GroupingInfo> groupingAcrossList = reportMetadata.getGroupingsAcross();
        
        String reportType = 'matrix';
        
        //added for return options
        List<List<String>> ReportContentLine = new List<List<String>>();
        List<String> ReportContentCellHeader = new List<String>();
        List<String> ReportContentCellTotals = new List<String>();

        reportResponse rr = new reportResponse();
		rr.reportType = reportType;	
        
		List<fieldDef> reportFields = new List<fieldDef>();	
		List<List<fieldData>> fieldDataList = new List<List<fieldData>>();	

		//get a string array of the field names
		List<String> fieldNames = reportMetadata.getDetailColumns();		
		
		//get the extended metadata
		Reports.ReportExtendedMetadata reportExtendedMetadata = results.getReportExtendedMetadata();

		//get the map of the column names to their name and label		
        Map<String, Reports.GroupingColumn> detailColumnMap = reportExtendedMetadata.getGroupingColumnInfo();

		//first add the grouping down field info
		Reports.GroupingInfo groupingInfoDown = reportMetadata.getGroupingsDown()[0]; //only supports one grouping level
		Reports.GroupingColumn groupingColumnDown = detailColumnMap.get(groupingInfoDown.getName());
		fieldDef fdGroupDown = new fieldDef();
		fdGroupDown.fieldName = groupingColumnDown.getName(); 
		fdGroupDown.fieldLabel = groupingColumnDown.getLabel();
		fdGroupDown.dataType = groupingColumnDown.getDataType().name();
		reportFields.add(fdGroupDown);
        system.debug(groupingColumnDown.getLabel());
		
        ReportContentCellHeader.add(groupingColumnDown.getLabel());            
        

		//now add all the groupings across
		for (Reports.GroupingValue groupingValue: results.getGroupingsAcross().getGroupings()) {
			fieldDef fd = new fieldDef();
			fd.fieldName = String.ValueOf(groupingValue.getValue()); 
			fd.fieldLabel = groupingValue.getLabel();
			fd.dataType = 'DOUBLE_DATA';
			reportFields.add(fd);
            ReportContentCellHeader.add(groupingValue.getLabel());
		}
        ReportContentCellHeader.add('TOTAL');
        ReportContentLine.add(ReportContentCellHeader);

        
        //get the matrix grouping down dimension grouping values.  only going 1 level deep
		List<summaryReportGroup> groupListDown = new List<summaryReportGroup>();
		for (Reports.GroupingValue groupingValue: results.getGroupingsDown().getGroupings()) {
			summaryReportGroup srg = new summaryReportGroup();
            //if(isDate(groupingValue.getValue())){}.date()
			srg.fieldValue = String.ValueOf(groupingValue.getValue());
            
			srg.fieldLabel = groupingValue.getLabel();	
			srg.groupKey = groupingValue.getKey();
			srg.isHyperLink = isHyperlink(srg.fieldValue);
			groupListDown.add(srg);
		}

		//get the matrix grouping across dimension grouping values.  only going 1 level deep
		List<summaryReportGroup> groupListAcross = new List<summaryReportGroup>();
		for (Reports.GroupingValue groupingValue: results.getGroupingsAcross().getGroupings()) {
			summaryReportGroup srg = new summaryReportGroup();
			srg.fieldValue = String.ValueOf(groupingValue.getValue());
			srg.fieldLabel = groupingValue.getLabel();
			srg.groupKey = groupingValue.getKey();
			srg.isHyperLink = isHyperlink(srg.fieldValue);
			groupListAcross.add(srg);
		}
        
        

		//now we need to do a nested loop of the groupings down and across to get all the data from the fact map
		for (summaryReportGroup down: groupListDown) {
			List<fieldData> fieldDataRow = new List<fieldData>();
			List<String> ReportContentCell = new List<String>();
            
			//first cell is the grouping down
			fieldData fd = new fieldData();
			fd.fieldValue = down.fieldValue;
			fd.fieldLabel = down.fieldLabel;
			fd.dataType = 'STRING_DATA';
			fd.isHyperLink = down.isHyperLink;
			fieldDataRow.add(fd);
            
            if(down.fieldValue==null){
            	ReportContentCell.add('N/A');
        	} else{
            	ReportContentCell.add(down.fieldLabel);
        	}
            
            Double LineTotal = 0;

			for (summaryReportGroup across: groupListAcross) {
				//use our composite down!across key to get values from the fact map
				Reports.ReportFactWithDetails factDetails = (Reports.ReportFactWithDetails)results.getFactMap().get(down.groupKey+'!'+across.groupKey);	
				Reports.SummaryValue summaryValue = factDetails.getAggregates()[0]; //only support 1 set of aggregates

				fd = new fieldData();
				fd.fieldValue = String.ValueOf( (summaryValue.getValue()+''));
				fd.fieldLabel = String.ValueOf( (summaryValue.getLabel()+''));
				fd.dataType = 'DOUBLE_DATA';
				fieldDataRow.add(fd);
                
                ReportContentCell.add( String.ValueOf( Math.roundToLong((Double)summaryValue.getValue()) +'' ));
                LineTotal = LineTotal + Double.valueOf(summaryValue.getValue());
			}
			//add the row to the list
			fieldDataList.add(fieldDataRow);
            ReportContentCell.add( String.ValueOf(Math.roundToLong(LineTotal)) );
            ReportContentLine.add(ReportContentCell);
		}

             
        
        //system.debug( ReportContentLine.Sum(ReportContentLine(1)) );
        //
        //
        //totals
        ReportContentCellTotals.add('TOTAL');
        
        Double ColTotal;
        Double GrandTotal;
        GrandTotal = 0;
        
        for (summaryReportGroup acrossTotal: groupListAcross) {
            ColTotal = 0;
           
            for (summaryReportGroup downTotal: groupListDown) {
                Reports.ReportFactWithDetails factDetails = (Reports.ReportFactWithDetails)results.getFactMap().get(downTotal.groupKey+'!'+acrossTotal.groupKey);	
				Reports.SummaryValue summaryValue = factDetails.getAggregates()[0]; //only support 1 set of aggregates
                
                ColTotal = ColTotal + Double.valueOf(summaryValue.getValue());
                GrandTotal = GrandTotal + Double.valueOf(summaryValue.getValue());
            }
            
            ReportContentCellTotals.add(String.ValueOf(Math.roundToLong(ColTotal)));
        }
        ReportContentCellTotals.add(String.ValueOf(Math.roundToLong(GrandTotal)));
        
        /*

        
        
        List<decimal> footerTotals = new List<decimal>();
		for (Integer i = 0; i < 4; i++)
		{
    		// Sum the columns
    		ReportContentCellTotals.Add(String.Valueof( ReportContentLine.Sum(ReportContentLine[i])) );
		}

        

       	for (summaryReportGroup downTotal: groupListDown) {
        	for (summaryReportGroup acrossTotal: groupListAcross) {
            	system.debug(groupListAcross);
            	
				//use our composite down!across key to get values from the fact map
				Reports.ReportFactWithDetails factDetails = (Reports.ReportFactWithDetails)results.getFactMap().get(downTotal.groupKey+'!'+acrossTotal.groupKey);	
				Reports.SummaryValue summaryValue = factDetails.getAggregates()[0]; //only support 1 set of aggregates
				
				fd = new fieldData();
				fd.fieldValue = String.ValueOf((summaryValue.getValue()+''));
				fd.fieldLabel = String.ValueOf((summaryValue.getLabel()+''));
				fd.dataType = 'DOUBLE_DATA';
				fieldDataRow.add(fd);
                
                ReportContentCell.add( String.ValueOf((summaryValue.getValue()+'')) );
				
			}
        }
		
        Double[] colTotal;
        Integer colCount;
        for (List<String> lines: ReportContentLine) {
            colCount=0;
            if(lines[0]<>'TOTAL'){
                for (String cols: lines) {
                    //if(colCount>0){ colTotal[colCount]=0; }
                    colCount=colCount+1;
                }
            }
        	//ReportContentCellTotals.add( sum(ReportContentLine) );
        }
        for (List<String> lines: ReportContentLine) {
            colCount=0;
            if(lines[0]<>'TOTAL'){
                for (String cols: lines) {
                    //if(colCount>0){ colTotal[colCount]=colTotal[colCount]+Double.valueOf(cols); }
                    colCount=colCount+1;
                }
            }
        	//ReportContentCellTotals.add( sum(ReportContentLine) );
        }

		*/

        ReportContentLine.add(ReportContentCellTotals);
        
		rr.reportFields = reportFields;
		rr.fieldDataList = fieldDataList;
        

        //system.debug(System.JSON.serialize(rr));
		system.debug(ReportContentLine);
		//return rr;
        return ReportContentLine;
        
    }
    
    public static Boolean isHyperlink(String sVal) {
		Boolean isHyperLink = true;
		Id theId;
		try {theId = (Id)sVal;}
		catch (Exception e) {isHyperLink = false;}
		return isHyperLink;
	}	
    
    public class fieldDef {
		public String fieldName {get; set;}
		public String fieldLabel {get; set;}
		public String dataType {get; set;}
		public fieldDef(){}
	}

	public class fieldData {
		public String fieldValue {get; set;}
		public String fieldLabel {get; set;}
		public String dataType  {get; set;}
		public Boolean isHyperLink {get; set;}			
		public fieldData(){isHyperLink=false;}
	}
    
    public class reportResponse {
		public String reportType {get; set;}
        public List<fieldDef> reportFields {get; set;}
		public List<List<fieldData>> fieldDataList {get; set;}
		//public tabularReportResponse tabResp {get; set;}
		//public summaryReportResponse sumResp {get; set;}		
		public reportResponse(){}
	}

	public class summaryReportResponse {
		public List<fieldDef> reportFields {get; set;}
		public List<summaryReportGroup> groupList {get; set;}
		public summaryReportResponse(){}
	}	
	
	public class summaryReportGroup {
		public String fieldName {get; set;}
		public String fieldValue {get; set;}
		public String fieldLabel {get; set;}
		public String groupKey {get; set;}
		public Boolean isHyperLink {get; set;}	
		public Integer fieldsInGroup {get; set;}					
		public List<List<fieldData>> fieldDataList {get; set;}
		public summaryReportGroup(){}
	}	

}