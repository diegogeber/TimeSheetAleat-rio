Declare @mes int
Declare @ano int

set @mes =10
set @ano = 2020

print dateadd(day,-1,DATEFROMPARTS(@ano,@mes,1))
print EOMONTH(DATEFROMPARTS(@ano,@mes,1))

create table #feriados (dia_f datetime,   f bit)
insert into #feriados (dia_f,f) values 
('2020-10-12',1),
('2020-11-15',1),
('2020-12-25',1)

;WITH dias 
     AS (SELECT 1                    AS ValorDia, 
              Dateadd(dd, 1,dateadd(day,-1,DATEFROMPARTS(@ano,@mes,1)))    dia 
         UNION ALL 
         SELECT valordia + 1, 
                Dateadd(dd, valordia + 1, dateadd(day,-1,DATEFROMPARTS(@ano,@mes,1))) dia 
         FROM   dias 
         WHERE  valordia < Datediff(dd, dateadd(day,-1,DATEFROMPARTS(@ano,@mes,1)), EOMONTH(DATEFROMPARTS(@ano,@mes,1))))
     
SELECT right('0' + cast(DATEPART(day,dia) as varchar),2) [Data], 
case f.f when 1 then 'S' else 'N' end [Feriado (S/N)],
       dia      AS DataBacklog,
	( case   datepart(WEEKDAY,dia)
	 when 1 then 'Domingo'
	 when 2 then 'Segunda'
	 when 3 then 'Terça'
	 when 4 then 'Quarta'
	 when 5 then 'Quinta'
	 when 6 then 'Sexta'
	 when 7 then 'Sábado' end) [Dia da Semana],
case when  datepart(WEEKDAY,dia) = 1 OR datepart(WEEKDAY,dia) = 7  OR isnull(f.f,0) = 1 then '' else CONVERT(VARCHAR, DATEADD(MINUTE, CAST(((5 + 1) - -5) * RAND(CHECKSUM(NEWID())) + -5 AS int), CONVERT(TIME, '09:00')), 108) end  [Hr Entrada],
case when  datepart(WEEKDAY,dia) = 1 OR datepart(WEEKDAY,dia) = 7  OR isnull(f.f,0) = 1 then '' else CONVERT(VARCHAR, DATEADD(MINUTE, CAST(((5 + 1) - 0) * RAND(CHECKSUM(NEWID())) + 0 AS TINYINT), CONVERT(TIME, '12:00')), 108) end  [Hr Entrada],
case when  datepart(WEEKDAY,dia) = 1 OR datepart(WEEKDAY,dia) = 7  OR isnull(f.f,0) = 1 then '' else CONVERT(VARCHAR, DATEADD(MINUTE, CAST(((5 + 1) - 0) * RAND(CHECKSUM(NEWID())) + 0 AS TINYINT), CONVERT(TIME, '13:00')), 108)  end [Hr Saida],
case when  datepart(WEEKDAY,dia) = 1 OR datepart(WEEKDAY,dia) = 7  OR isnull(f.f,0) = 1 then '' else CONVERT(VARCHAR, DATEADD(MINUTE, CAST(((5 + 1) - 0) * RAND(CHECKSUM(NEWID())) + 0 AS TINYINT), CONVERT(TIME, '18:00')), 108) end  [Hr Saída]

FROM   dias left join #feriados f on dias.dia = f.dia_f
        
ORDER  BY valordia option (maxrecursion 0)  

drop table #feriados
