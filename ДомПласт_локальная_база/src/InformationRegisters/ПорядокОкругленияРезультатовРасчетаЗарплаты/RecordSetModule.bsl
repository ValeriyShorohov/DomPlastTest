#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаОкругления Из ЭтотОбъект Цикл
		
		Если СтрокаОкругления.ВидРасчета = Справочники.НалогиСборыОтчисления.ВзносыОбязательноеСоциальноеМедицинскоеСтрахование
			И СтрокаОкругления.Период >= Дата(2020, 1, 1) Тогда
			
			СообщениеОбОшибке = НСтр("ru = 'Данные о порядке округления ""Взносы на обязательное социальное медицинское страхование"" вводятся до 2020 года. С 2020 года округление производится автоматически, согласно действующим нормам законодательства.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке);
			Отказ = Истина;

        ИначеЕсли СтрокаОкругления.ВидРасчета = Справочники.НалогиСборыОтчисления.ОтчисленияОбязательноеСоциальноеМедицинскоеСтрахование
            И СтрокаОкругления.Период >= Дата(2022, 1, 1) Тогда
            
            СообщениеОбОшибке = НСтр("ru = 'Данные о порядке округления ""Отчисления на обязательное социальное медицинское страхование"" вводятся до 2022 года. С 2022 года округление производится автоматически, согласно действующим нормам законодательства.'");
            ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке);
            Отказ = Истина;
            
        ИначеЕсли СтрокаОкругления.ВидРасчета = Справочники.НалогиСборыОтчисления.ОбязательныеСоциальныеОтчисления
            И СтрокаОкругления.Период >= Дата(2022, 1, 1) Тогда
            
			Если СтрокаОкругления.ПорядокОкругления = Перечисления.ПорядкиОкругления.Окр0_5
				ИЛИ СтрокаОкругления.ПорядокОкругления = Перечисления.ПорядкиОкругления.Окр0_5 
				ИЛИ СтрокаОкругления.ПорядокОкругления = Перечисления.ПорядкиОкругления.Окр0_05 
				ИЛИ СтрокаОкругления.ПорядокОкругления = Перечисления.ПорядкиОкругления.Окр0_1
				ИЛИ СтрокаОкругления.ПорядокОкругления = Перечисления.ПорядкиОкругления.Окр0_01 Тогда
                
                СообщениеОбОшибке = НСтр("ru = 'Порядок округления ""Социальных отчислений"" регламентирован, необходимо выбрать округление до целого.'");
                ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке);
                Отказ = Истина;
				
			КонецЕсли;

		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры
	
#КонецЕсли