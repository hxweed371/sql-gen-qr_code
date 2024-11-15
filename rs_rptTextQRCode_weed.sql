create PROCEDURE [dbo].[rs_rptTextQRCode_weed]  
AS  
BEGIN  
 SET NOCOUNT ON  
 SET ANSI_NULLS OFF  
 --Attention in case of wrong bank BIN code
 DECLARE @IDPayloadFormatIndicator varchar(4000),@lenPayloadFormatIndicator varchar(4000),@PayloadFormatIndicator varchar(4000)
 DECLARE @IDPointOfInitiationMethod varchar(4000),@lenPointOfInitiationMethod varchar(4000),@PointOfInitiationMethod varchar(4000)
 DECLARE @IDConsumerAccountInformation varchar(4000),@lenConsumerAccountInformation varchar(4000),@ConsumerAccountInformation varchar(4000)
		,@IDBank varchar(4000),@lenBank varchar(4000),@GUID varchar(4000), @NAPAS247 varchar(4000)
		,@IDBinBank varchar(4000),@lenBinBank varchar(4000),@BinBank varchar(4000)
		,@IDBankAccount varchar(4000),@lenBankAccount varchar(4000),@BankAccount varchar(4000)
 DECLARE @IDTransactionCurrency varchar(4000),@lenIDTransactionCurrency varchar(4000),@TransactionCurrency varchar(4000)
 DECLARE @IDTransactionAmount varchar(4000),@lenTransactionAmount varchar(4000),@TransactionAmount varchar(4000)
 DECLARE @IDCountryCode varchar(4000),@lenCountryCode varchar(4000),@CountryCode varchar(4000)
 DECLARE @IDAdditionalDataFieldTemplate varchar(4000),@lenAdditionalDataFieldTemplate varchar(4000),@AdditionalDataFieldTemplate varchar(4000)
 DECLARE @lenAdditionalDataFieldTemplate2 varchar(4000)
 DECLARE @IDCRC varchar(4000),@lenCRC varchar(4000)='04',@CRC varchar(4000)


 select @IDPayloadFormatIndicator=IDPayloadFormatIndicator, @PayloadFormatIndicator = PayloadFormatIndicator 
  	   
	   ,@IDPointOfInitiationMethod=IDPointOfInitiationMethod, @PointOfInitiationMethod = PointOfInitiationMethod
	   
	   ,@IDConsumerAccountInformation=IDConsumerAccountInformation,@IDBank = IDBank
	   ,@GUID ='0010A000000727', @NAPAS247 ='0208QRIBFTTA'
	   ,@IDBinBank=IDBinBank,@BinBank=BinBank
	   ,@IDBankAccount=IDBankAccount,@BankAccount=BankAccount

	   ,@IDTransactionCurrency=IDTransactionCurrency,@TransactionCurrency=TransactionCurrency
	   ,@IDTransactionAmount=IDTransactionAmount
	   ,@IDCountryCode=IDCountryCode,@CountryCode=CountryCode
	   ,@IDAdditionalDataFieldTemplate=IDAdditionalDataFieldTemplate
	   ,@IDCRC=IDCRC

 from #SetUPQRCode where default_yn = 1

 
 select @lenPayloadFormatIndicator = CASE 
    WHEN LEN(@PayloadFormatIndicator) < 10 THEN RIGHT('0' + CAST(LEN(@PayloadFormatIndicator) AS NVARCHAR(3)), 3)
    ELSE CAST(LEN(@PayloadFormatIndicator) AS NVARCHAR(3))
 END
 select @lenPointOfInitiationMethod = CASE 
    WHEN LEN(@PointOfInitiationMethod) < 10 THEN RIGHT('0' + CAST(LEN(@PointOfInitiationMethod) AS NVARCHAR(3)), 3)
    ELSE CAST(LEN(@PointOfInitiationMethod) AS NVARCHAR(3))
 END

 select @lenBinBank = CASE 
    WHEN LEN(@BinBank) < 10 THEN RIGHT('0' + CAST(LEN(@BinBank) AS NVARCHAR(3)), 3)
    ELSE CAST(LEN(@BinBank) AS NVARCHAR(3))
 END
 select @lenBankAccount = CASE 
    WHEN LEN(@BankAccount) < 10 THEN RIGHT('0' + CAST(LEN(@BankAccount) AS NVARCHAR(3)), 3)
    ELSE CAST(LEN(@BankAccount) AS NVARCHAR(3))
 END 

 select @lenIDTransactionCurrency = CASE 
    WHEN LEN(@TransactionCurrency) < 10 THEN RIGHT('0' + CAST(LEN(@TransactionCurrency) AS NVARCHAR(3)), 3)
    ELSE CAST(LEN(@TransactionCurrency) AS NVARCHAR(3))
 END 
 select @lenCountryCode = CASE 
    WHEN LEN(@CountryCode) < 10 THEN RIGHT('0' + CAST(LEN(@CountryCode) AS NVARCHAR(3)), 3)
    ELSE CAST(LEN(@CountryCode) AS NVARCHAR(3))
 END
 
 DECLARE @bank_infomation NVARCHAR(4000)
 select @bank_infomation = @IDBinBank+@lenBinBank+@BinBank+@IdBankAccount+@lenBankAccount+@BankAccount

 select @lenBank = CASE 
    WHEN LEN(@bank_infomation) < 10 THEN RIGHT('0' + CAST(LEN(@bank_infomation) AS NVARCHAR(3)), 3)
    ELSE CAST(LEN(@bank_infomation) AS NVARCHAR(3))
 END

 select @ConsumerAccountInformation = @GUID+ @IDBank+@lenBank+@bank_infomation +@NAPAS247

 select @lenConsumerAccountInformation = CASE 
    WHEN LEN(@ConsumerAccountInformation) < 10 THEN RIGHT('0' + CAST(LEN(@ConsumerAccountInformation) AS NVARCHAR(3)), 3)
    ELSE CAST(LEN(@ConsumerAccountInformation) AS NVARCHAR(3))
 END

 create table #loop(ID INT IDENTITY(1,1), stt_rec char(13), ghi_chu varchar(4000),thanh_tien int,qr_text varchar(max))

 insert into #loop (stt_rec,ghi_chu,thanh_tien)
 select distinct a.stt_rec,ltrim(rtrim(a.ma_kh))+ ' ' + dbo.GetUnsignString(b.ten_kh) + ' ' + convert(varchar,ngay_ct,103)+ ' ' + ltrim(rtrim(so_ct)),convert(int,t_tt_nt)
 from #result a left join #dmkh b on a.ma_kh = b.ma_kh
 where  a.stt_rec <> '' and a.ma_kh <>'' and b.ten_kh <> '' and a.ngay_ct <>''
 

 DECLARE @i int, @c int, @stt_rec char(13), @ghi_chu  varchar(4000), @thanh_tien int

 DECLARE @input varchar(MAX)
 
 select @input = @IDPayloadFormatIndicator+@lenPayloadFormatIndicator+@PayloadFormatIndicator
 select @input+= @IDPointOfInitiationMethod+@lenPointOfInitiationMethod+@PointOfInitiationMethod
 select @input+= @IDConsumerAccountInformation+@lenConsumerAccountInformation+@ConsumerAccountInformation
 select @input+= @IDTransactionCurrency+@lenIDTransactionCurrency+@TransactionCurrency
 
 select @i = 1, @c = count(1) from #loop

 while @i <= @c begin
	-- @ghi_chu transfer content
	-- @thanh_tien money transfer
	select @ghi_chu = ghi_chu, @thanh_tien = thanh_tien from #loop where id = @i
	
	select @TransactionAmount = convert(nvarchar,convert(int,@thanh_tien))
	select @lenTransactionAmount = CASE 
		WHEN LEN(@TransactionAmount) < 10 THEN RIGHT('0' + CAST(LEN(@TransactionAmount) AS NVARCHAR(3)), 3)
		ELSE CAST(LEN(@TransactionAmount) AS NVARCHAR(3))
	 END
	select @AdditionalDataFieldTemplate = @ghi_chu
	select @lenAdditionalDataFieldTemplate = CASE 
		WHEN LEN(@AdditionalDataFieldTemplate) < 10 THEN RIGHT('0' + CAST(LEN(@AdditionalDataFieldTemplate) AS NVARCHAR(3)), 3)
		ELSE CAST(LEN(@AdditionalDataFieldTemplate) AS NVARCHAR(3))
	 END

	select @lenAdditionalDataFieldTemplate2 = CASE 
		WHEN LEN(@IDAdditionalDataFieldTemplate+@lenAdditionalDataFieldTemplate+@AdditionalDataFieldTemplate) < 10 
			 THEN RIGHT('0' + CAST(LEN(@IDAdditionalDataFieldTemplate+@lenAdditionalDataFieldTemplate+@AdditionalDataFieldTemplate) AS NVARCHAR(3)), 3)
		ELSE CAST(LEN(@IDAdditionalDataFieldTemplate+@lenAdditionalDataFieldTemplate+@AdditionalDataFieldTemplate) AS NVARCHAR(3))
	 END


    select @input+= @IDTransactionAmount+@lenTransactionAmount+@TransactionAmount
    select @input+= @IDCountryCode+@lenCountryCode+@CountryCode
	
    select @input+= @IDAdditionalDataFieldTemplate+@lenAdditionalDataFieldTemplate2+'08'+@lenAdditionalDataFieldTemplate+@AdditionalDataFieldTemplate
	
	select @input+= @IDCRC +@lenCRC
	SELECT @CRC = dbo.CRC_CCITT_0xFFFF(CONVERT(VARBINARY(MAX), @input)) 
	select @input+= @CRC

	update  #loop set qr_text = @input where id = @i
	select @i = @i +1 
 end
 
 alter table #result add  CRC varchar(max),qr_text varchar(max)
 update a set CRC = @CRC,a.qr_text = b.qr_text from #result a join #loop b on a.stt_rec = b.stt_rec
 SET NOCOUNT OFF  
 SET ANSI_NULLS ON  
END 
