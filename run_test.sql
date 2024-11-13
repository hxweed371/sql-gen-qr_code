CREATE TABLE [#SetUPQRCode](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[NameAccount] [varchar](4000) NOT NULL,
	[BankName] [varchar](4000) NULL,
	[IDPayloadFormatIndicator] [varchar](4000) NULL,
	[PayloadFormatIndicator] [varchar](4000) NULL,
	[IDPointOfInitiationMethod] [varchar](4000) NULL,
	[PointOfInitiationMethod] [varchar](4000) NULL,
	[IDConsumerAccountInformation] [varchar](4000) NULL,
	[IDBank] [varchar](4000) NULL,
	[IDBinBank] [varchar](4000) NULL,
	[BinBank] [varchar](4000) NULL,
	[IDBankAccount] [varchar](4000) NULL,
	[BankAccount] [varchar](4000) NULL,
	[IDTransactionCurrency] [varchar](4000) NULL,
	[TransactionCurrency] [varchar](4000) NULL,
	[IDTransactionAmount] [varchar](4000) NULL,
	[IDCountryCode] [varchar](4000) NULL,
	[CountryCode] [varchar](4000) NULL,
	[IDAdditionalDataFieldTemplate] [varchar](4000) NULL,
	[IDCRC] [varchar](4000) NULL,
	[default_yn] [bit] NULL,)

INSERT INTO [#SetUPQRCode]([NameAccount],[BankName],[IDPayloadFormatIndicator],[PayloadFormatIndicator],[IDPointOfInitiationMethod],[PointOfInitiationMethod],[IDConsumerAccountInformation],[IDBank],[IDBinBank],[BinBank],[IDBankAccount],[BankAccount],[IDTransactionCurrency],[TransactionCurrency],[IDTransactionAmount],[IDCountryCode],[CountryCode],[IDAdditionalDataFieldTemplate],[IDCRC],[default_yn])
VALUES(N'LINH',N'VIETINBANK',N'00',N'01',N'01',N'12',N'38',N'01',N'00',N'970415',N'01',N'111602391111',N'53',N'704',N'54',N'58',N'VN',N'62',N'63',N'1')

create table #result(stt_rec char(13),ma_kh nvarchar(32),ngay_ct datetime,so_ct nvarchar(32),t_tt_nt int)
insert into #result select '1111111','hxweed371',GETDATE(),'so_ct111',28052001
create table #dmkh(ma_kh nvarchar(32),ten_kh nvarchar(32))
insert into #dmkh select 'hxweed371','hx weed 371'

exec rs_rptTextQRCode_weed
select * from #result
drop table #result,#dmkh, #SetUPQRCode

