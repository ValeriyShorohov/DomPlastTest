
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры,,"ЗакрыватьПриВыборе,ЗакрыватьПриЗакрытииВладельца");
	
	СтруктураПараметров = ИзменяемыеРеквизиты(Параметры);
	
	ЭтотОбъект.ЗначенияПриОткрытии = СтруктураПараметров;
	
	МассивЭлементов = Новый Массив();
	
	Для Каждого ЭлементСтруктуры из СтруктураПараметров Цикл
		МассивЭлементов.Добавить(ЭлементСтруктуры.Ключ);
	КонецЦикла;

	Если ТолькоПросмотр Тогда 	
				
		ОбщегоНазначенияБККлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "ТолькоПросмотр", Истина);
		
	КонецЕсли;  

	ПодготовитьФормуНаСервере();
	
	ЗапретРедактированияРеквизитовОбъектовПереопределяемый.ЗаблокироватьРеквизиты(ЭтотОбъект, Проведен, Параметры);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	ИначеЕсли  Модифицированность И НЕ ПеренестиВДокумент Тогда
		Отказ = Истина;
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗакрытиемФормыЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Да);
	КонецЕсли;
	
	Если Отказ Тогда
		ПеренестиВДокумент = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ПеренестиВДокумент И Модифицированность Тогда
		СтруктураРезультат = Новый Структура();
		СтруктураРезультат.Вставить("ВключатьКомиссиюБанка", 			 ЭтотОбъект.ВключатьКомиссиюБанка);
		СтруктураРезультат.Вставить("ПроцентКомиссии", 				 	 ЭтотОбъект.ПроцентКомиссии);
		СтруктураРезультат.Вставить("СуммаКомиссии", 		 			 ЭтотОбъект.СуммаКомиссии);
		СтруктураРезультат.Вставить("СтатьяДвиженияДенежныхСредств",	 ЭтотОбъект.СтатьяДвиженияДенежныхСредств);
		СтруктураРезультат.Вставить("СчетУчетаРасчетовСКонтрагентомБУ",  ЭтотОбъект.СчетУчетаРасчетовСКонтрагентомБУ);
		СтруктураРезультат.Вставить("СчетУчетаРасчетовСКонтрагентомНУ",  ЭтотОбъект.СчетУчетаРасчетовСКонтрагентомНУ);
		СтруктураРезультат.Вставить("СубконтоДтБУ1",					 ЭтотОбъект.СубконтоДтБУ1);
		СтруктураРезультат.Вставить("СубконтоДтБУ2",					 ЭтотОбъект.СубконтоДтБУ2);
		СтруктураРезультат.Вставить("СубконтоДтБУ3",					 ЭтотОбъект.СубконтоДтБУ3);
		СтруктураРезультат.Вставить("СубконтоДтНУ1",					 ЭтотОбъект.СубконтоДтНУ1);
		СтруктураРезультат.Вставить("СубконтоДтНУ2",					 ЭтотОбъект.СубконтоДтНУ2);
		СтруктураРезультат.Вставить("СубконтоДтНУ3",					 ЭтотОбъект.СубконтоДтНУ3);
		
		// Дополнительные реквизиты 
		СтруктураРезультат.Вставить("НазначениеПлатежа",		 	 	 ЭтаФорма.НазначениеПлатежа);
		СтруктураРезультат.Вставить("ИнформационнаяНадписьИтого",	 	 ЭтаФорма.ИнформационнаяНадписьИтого);
		
		ОповеститьОВыборе(СтруктураРезультат);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийПолей

&НаКлиенте
Процедура ВключатьКомиссиюБанкаПриИзменении(Элемент)
	
	ВключатьКомиссиюБанкаПриИзмененииНаСервере();
	УстановитьДоступностьРеквизитовКомиссииБанка(ЭтаФорма);
	
	ОбновитьПодвал(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ВключатьКомиссиюБанкаПриИзмененииНаСервере()

	Если ЭтотОбъект.ВключатьКомиссиюБанка И ЗначениеЗаполнено(ЭтотОбъект.СчетОрганизации) Тогда
		ЗаполнитьРеквизитыКомиссии();	
	КонецЕсли;
	
	РассчитатьСуммуКомиссии(ЭтаФорма);
	
	ОбновитьПодвал(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцентКомиссииПриИзменении(Элемент)
	
	РассчитатьСуммуКомиссии(ЭтаФорма);
	ОбновитьПодвал(ЭтаФорма);
		
КонецПроцедуры

&НаКлиенте
Процедура СуммаКомиссииПриИзменении(Элемент)
	
	ОбновитьПодвал(ЭтаФорма);
		
КонецПроцедуры

&НаКлиенте
Процедура СтатьяДвиженияДенежныхСредствКомиссияПриИзменении(Элемент)
	
	УстановитьСтатьюДДСВАналитикеСчета();
	
КонецПроцедуры

&НаКлиенте
Процедура СчетУчетаКомисииПриИзменении(Элемент)
	
	ЭтотОбъект.СчетУчетаРасчетовСКонтрагентомНУ = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПреобразоватьСчетаБУвСчетНУ(Новый Структура("СчетБУ", ЭтотОбъект.СчетУчетаРасчетовСКонтрагентомБУ));
	
	ПоляФормы		= Новый Структура("Субконто1, Субконто2, Субконто3",
		"СубконтоДтНУ1", "СубконтоДтНУ2", "СубконтоДтНУ3");

	ПроцедурыБухгалтерскогоУчетаКлиентСервер.ПриИзмененииСчета(ЭтотОбъект.СчетУчетаРасчетовСКонтрагентомНУ, ЭтотОбъект, ПоляФормы);

	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, ЭтотОбъект.СчетУчетаРасчетовСКонтрагентомБУ,,, ЭтотОбъект.СчетУчетаРасчетовСКонтрагентомНУ);
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ДтБУ", , "СчетУчетаРасчетовСКонтрагентомБУ");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ДтНУ", , "СчетУчетаРасчетовСКонтрагентомНУ");
	
	ДанныеОбъекта = Новый Структура("Организация, СубконтоДтБУ1, СубконтоДтБУ2, СубконтоДтБУ3,
									|СубконтоДтНУ1, СубконтоДтНУ2, СубконтоДтНУ3");
			
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, ЭтотОбъект);
		
	ПроверитьВладельцаСубконтоПодразделениеБУНУ(ДанныеОбъекта);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеОбъекта);
	
	УстановитьСтатьюДДСВАналитикеСчета();

КонецПроцедуры

&НаКлиенте
Процедура СчетУчетаНУКомисииПриИзменении(Элемент)
	
	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, ЭтотОбъект.СчетУчетаРасчетовСКонтрагентомБУ,,, ЭтотОбъект.СчетУчетаРасчетовСКонтрагентомНУ);
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ДтНУ", , "СчетУчетаРасчетовСКонтрагентомНУ");
	
	ДанныеОбъекта = Новый Структура("Организация, СубконтоДтНУ1, СубконтоДтНУ2, СубконтоДтНУ3");
			
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, ЭтотОбъект);
		
	СчетУчетаНУПриИзмененииНаСервере(ДанныеОбъекта);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеОбъекта);

КонецПроцедуры

&НаКлиенте
Процедура СубконтоДтБУ1КомиссииПриИзменении(Элемент)
	
	ОбщегоНазначенияБККлиентСервер.ЗаменитьСубконтоНУ(ЭтотОбъект, ЭтотОбъект.СчетУчетаРасчетовСКонтрагентомБУ, ЭтотОбъект.СчетУчетаРасчетовСКонтрагентомНУ, 1, ЭтотОбъект.СубконтоДтБУ1, "СубконтоДтНУ");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ДтБУ", , "СчетУчетаРасчетовСКонтрагентомБУ");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ДтНУ", , "СчетУчетаРасчетовСКонтрагентомНУ", Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДтБУ2КомиссииПриИзменении(Элемент)
	
	ОбщегоНазначенияБККлиентСервер.ЗаменитьСубконтоНУ(ЭтотОбъект, ЭтотОбъект.СчетУчетаРасчетовСКонтрагентомБУ, ЭтотОбъект.СчетУчетаРасчетовСКонтрагентомНУ, 2, ЭтотОбъект.СубконтоДтБУ2, "СубконтоДтНУ");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ДтБУ", , "СчетУчетаРасчетовСКонтрагентомБУ");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ДтНУ", , "СчетУчетаРасчетовСКонтрагентомНУ", Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДтБУ3КомиссииПриИзменении(Элемент)
	
	ОбщегоНазначенияБККлиентСервер.ЗаменитьСубконтоНУ(ЭтотОбъект, ЭтотОбъект.СчетУчетаРасчетовСКонтрагентомБУ, ЭтотОбъект.СчетУчетаРасчетовСКонтрагентомНУ, 3, ЭтотОбъект.СубконтоДтБУ3, "СубконтоДтНУ");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ДтБУ", , "СчетУчетаРасчетовСКонтрагентомБУ");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ДтНУ", , "СчетУчетаРасчетовСКонтрагентомНУ", Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДтБУ1КомиссииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоДтБУ", 1, "СчетУчетаРасчетовСКонтрагентомБУ", ЭтотОбъект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДтБУ2КомиссииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоДтБУ", 2, "СчетУчетаРасчетовСКонтрагентомБУ", ЭтотОбъект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДтБУ3КомиссииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоДтБУ", 3, "СчетУчетаРасчетовСКонтрагентомБУ", ЭтотОбъект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДтНУ1КомиссииПриИзменении(Элемент)

	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ДтНУ", , "СчетУчетаРасчетовСКонтрагентомНУ");

КонецПроцедуры

&НаКлиенте
Процедура СубконтоДтНУ2КомиссииПриИзменении(Элемент)

	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ДтНУ", , "СчетУчетаРасчетовСКонтрагентомНУ");

КонецПроцедуры

&НаКлиенте
Процедура СубконтоДтНУ3КомиссииПриИзменении(Элемент)

	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ДтНУ", , "СчетУчетаРасчетовСКонтрагентомНУ");

КонецПроцедуры

&НаКлиенте
Процедура СубконтоДтНУ1КомиссииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоДтНУ", 1, "СчетУчетаРасчетовСКонтрагентомНУ", ЭтотОбъект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДтНУ2КомиссииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоДтНУ", 2, "СчетУчетаРасчетовСКонтрагентомНУ", ЭтотОбъект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДтНУ3КомиссииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоДтНУ", 3, "СчетУчетаРасчетовСКонтрагентомНУ", ЭтотОбъект, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если ЭтаФорма.ПоказыватьВДокументахСчетаУчета И ЭтаФорма.ВключатьКомиссиюБанка Тогда
		
		ОбязательныеПоляЗаполнены = ЭтаФорма.ПроверитьЗаполнение(); 
		
		Если ОбязательныеПоляЗаполнены Тогда
			ЗакрытьССохранением();
		КонецЕсли;
	Иначе
		ЗакрытьССохранением();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьССохранением()
	
	ПеренестиВДокумент = Истина;
	
	ЗначенияИзменились = ПроверитьЗначения();
	
	Если ЗначенияИзменились Тогда
		Модифицированность = Истина;
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Модифицированность = Ложь;
	ПеренестиВДокумент = Ложь;
	Закрыть();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИзменяемыеРеквизиты(Источник)
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("ВключатьКомиссиюБанка", 			 Источник.ВключатьКомиссиюБанка);
	СтруктураПараметров.Вставить("ПроцентКомиссии", 				 Источник.ПроцентКомиссии);
	СтруктураПараметров.Вставить("СуммаКомиссии", 		 			 Источник.СуммаКомиссии);
	СтруктураПараметров.Вставить("СтатьяДвиженияДенежныхСредств",	 Источник.СтатьяДвиженияДенежныхСредств);
	СтруктураПараметров.Вставить("СчетУчетаРасчетовСКонтрагентомБУ", Источник.СчетУчетаРасчетовСКонтрагентомБУ);
	СтруктураПараметров.Вставить("СчетУчетаРасчетовСКонтрагентомНУ", Источник.СчетУчетаРасчетовСКонтрагентомНУ);
	СтруктураПараметров.Вставить("СубконтоДтБУ1",					 Источник.СубконтоДтБУ1);
	СтруктураПараметров.Вставить("СубконтоДтБУ2",					 Источник.СубконтоДтБУ2);
	СтруктураПараметров.Вставить("СубконтоДтБУ3",					 Источник.СубконтоДтБУ3);
	СтруктураПараметров.Вставить("СубконтоДтНУ1",					 Источник.СубконтоДтНУ1);
	СтруктураПараметров.Вставить("СубконтоДтНУ2",					 Источник.СубконтоДтНУ2);
	СтруктураПараметров.Вставить("СубконтоДтНУ3",					 Источник.СубконтоДтНУ3);
		
	Возврат СтруктураПараметров;
	
КонецФункции

&НаКлиенте
Процедура ВопросПередЗакрытиемФормыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПеренестиВДокумент = Истина;
		Закрыть();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		ПеренестиВДокумент = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	ЭтотОбъект.ВалютаРегламентированногоУчета = ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	НастройкиПользователя = ПользователиБКВызовСервераПовтИсп.ЗначенияНастроекПользователя(
								Пользователи.ТекущийПользователь(), "ПоказыватьВДокументахСчетаУчета,УчетПоВсемОрганизациям");
		
	ЭтотОбъект.ПоказыватьВДокументахСчетаУчета = НастройкиПользователя.ПоказыватьВДокументахСчетаУчета;
	
	ЭтотОбъект.ПоддержкаРаботыСоСтруктурнымиПодразделениями = ПолучитьФункциональнуюОпцию("ПоддержкаРаботыСоСтруктурнымиПодразделениями");
	
	Если ЭтотОбъект.ВидОперации = Перечисления.ВидыОперацийППИсходящее.ПеречислениеНалога
		ИЛИ ЭтотОбъект.ВидОперации = Перечисления.ВидыОперацийППИсходящее.ПеречислениеНДССИзмененнымСрокомУплаты Тогда
		
		ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ДтБУ", "ПеречислениеНалогов", "СчетУчетаРасчетовСКонтрагентомБУ");	
		ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ДтНУ", "ПеречислениеНалогов", "СчетУчетаРасчетовСКонтрагентомНУ");
		
		УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, ЭтотОбъект.СчетУчетаРасчетовСКонтрагентомБУ, , "ПеречислениеНалогов", ЭтотОбъект.СчетУчетаРасчетовСКонтрагентомНУ);
		
	ИначеЕсли ЭтотОбъект.ВидОперации = Перечисления.ВидыОперацийППИсходящее.ПрочееСписаниеБезналичныхДенежныхСредств Тогда
		
		ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ДтБУ",, "СчетУчетаРасчетовСКонтрагентомБУ");	
		ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ДтНУ",, "СчетУчетаРасчетовСКонтрагентомНУ");
				
		УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, ЭтотОбъект.СчетУчетаРасчетовСКонтрагентомБУ, , , ЭтотОбъект.СчетУчетаРасчетовСКонтрагентомНУ);
		
	ИначеЕсли ЕстьРасшифровкаПлатежа 
		ИЛИ ЭтотОбъект.ВидОперации = Перечисления.ВидыОперацийППИсходящее.ПеречислениеЗаработнойПлаты
		ИЛИ ЭтотОбъект.ВидОперации = Перечисления.ВидыОперацийППИсходящее.ПеречислениеПенсионныхВзносов 
		ИЛИ ЭтотОбъект.ВидОперации = Перечисления.ВидыОперацийППИсходящее.ПеречислениеПоИсполнительнымЛистам
		ИЛИ ЭтотОбъект.ВидОперации = Перечисления.ВидыОперацийППИсходящее.ПеречислениеСоциальныхОтчислений
		ИЛИ ЭтотОбъект.ВидОперации = Перечисления.ВидыОперацийППИсходящее.ПеречислениеДенежныхСредствПодотчетнику Тогда
		
		ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ДтБУ", , "СчетУчетаРасчетовСКонтрагентомБУ");	
		ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ДтНУ", , "СчетУчетаРасчетовСКонтрагентомНУ");
		
		УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, ЭтотОбъект.СчетУчетаРасчетовСКонтрагентомБУ, , , ЭтотОбъект.СчетУчетаРасчетовСКонтрагентомНУ);
		
	КонецЕсли; 
	
	УстановитьДоступностьРеквизитовКомиссииБанка(ЭтаФорма);
	
	Элементы.ГруппаАналитикаКомиссияНУ.Видимость = ЭтаФорма.ВидимостьНалоговогоУчета;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьРеквизитовКомиссииБанка(Форма)
	
	ЭтотОбъект   = Форма.ЭтотОбъект;
	Элементы = Форма.Элементы;
	
	Элементы.ПроцентКомиссии.Доступность = ЭтотОбъект.ВключатьКомиссиюБанка;
	Элементы.СуммаКомиссии.Доступность   = ЭтотОбъект.ВключатьКомиссиюБанка;
	
	Элементы.СтатьяДвиженияДенежныхСредств.Доступность = ЭтотОбъект.ВключатьКомиссиюБанка; 		
	
	Если Не ЭтотОбъект.ПоказыватьВДокументахСчетаУчета Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаКомиссияСчетаАналитика", "Видимость", Ложь);
	Иначе
		Элементы.СчетУчетаРасчетовСКонтрагентомБУ.Доступность = ЭтотОбъект.ВключатьКомиссиюБанка;
		Элементы.СчетУчетаРасчетовСКонтрагентомНУ.Доступность = ЭтотОбъект.ВключатьКомиссиюБанка;		
		
		Для Счетчик = 1 По 3 Цикл
			Элементы["СубконтоДтБУ" + Счетчик].Доступность = ЭтотОбъект.ВключатьКомиссиюБанка;
			Элементы["СубконтоДтНУ" + Счетчик].Доступность = ЭтотОбъект.ВключатьКомиссиюБанка;
		КонецЦикла;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПодвал(Форма)
	
	ЭтотОбъект = Форма.ЭтотОбъект;
	
	СуммаИтого = "Всего: " + ?(ЭтотОбъект.ВключатьКомиссиюБанка, ЭтотОбъект.СуммаДокумента + ЭтотОбъект.СуммаКомиссии, ЭтотОбъект.СуммаДокумента) + " " + ЭтотОбъект.ВалютаДокумента;
	
	Если ЭтотОбъект.ВалютаДокумента <> Форма.ВалютаРегламентированногоУчета
		 //И (НЕ ЭлементыФормы.КурсВзаиморасчетов.Видимость) 
		 Тогда
		СуммаИтого = СуммаИтого + ", курс: " + Форма.КурсДокумента;
	КонецЕсли;
	
	Форма.ИнформационнаяНадписьИтого = СуммаИтого;
	
	Если ЭтотОбъект.ВключатьКомиссиюБанка И ЭтотОбъект.СуммаКомиссии <> 0 Тогда
		Форма.ИнформационнаяНадписьИтого = Форма.ИнформационнаяНадписьИтого + НСтр("ru = ', в т.ч. комиссия '") + ЭтотОбъект.СуммаКомиссии + " " + ЭтотОбъект.ВалютаДокумента;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыКомиссии()

	ЭтотОбъект.ПроцентКомиссии = ЭтотОбъект.СчетОрганизации.ПроцентКомиссии;
	ЭтотОбъект.СтатьяДвиженияДенежныхСредств     = ЭтотОбъект.СчетОрганизации.СтатьяДвиженияДенежныхСредств;
	
	ЭтотОбъект.СчетУчетаРасчетовСКонтрагентомБУ  = ЭтотОбъект.СчетОрганизации.СчетЗатратБУ;
	ЭтотОбъект.СубконтоДтБУ1					 = ЭтотОбъект.СчетОрганизации.СубконтоЗатратБУ1;
	ЭтотОбъект.СубконтоДтБУ2					 = ЭтотОбъект.СчетОрганизации.СубконтоЗатратБУ2;
	ЭтотОбъект.СубконтоДтБУ3					 = ЭтотОбъект.СчетОрганизации.СубконтоЗатратБУ3;
	
	ЭтотОбъект.СчетУчетаРасчетовСКонтрагентомНУ  = ЭтотОбъект.СчетОрганизации.СчетЗатратНУ;
	ЭтотОбъект.СубконтоДтНУ1					 = ЭтотОбъект.СчетОрганизации.СубконтоЗатратНУ1;
	ЭтотОбъект.СубконтоДтНУ2					 = ЭтотОбъект.СчетОрганизации.СубконтоЗатратНУ2;
	ЭтотОбъект.СубконтоДтНУ3					 = ЭтотОбъект.СчетОрганизации.СубконтоЗатратНУ3;
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ДтБУ", , "СчетУчетаРасчетовСКонтрагентомБУ");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ДтНУ", , "СчетУчетаРасчетовСКонтрагентомНУ");

	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, ЭтотОбъект.СчетУчетаРасчетовСКонтрагентомБУ,,, ЭтотОбъект.СчетУчетаРасчетовСКонтрагентомНУ);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьСуммуКомиссии(Форма)
	
	ЭтотОбъект = Форма.ЭтотОбъект;
	
	Если ЭтотОбъект.ВключатьКомиссиюБанка Тогда
		ЭтотОбъект.СуммаКомиссии = Окр(ЭтотОбъект.ПроцентКомиссии / 100 * ЭтотОбъект.СуммаДокумента, 2);		
	Иначе
		ЭтотОбъект.СуммаКомиссии = 0;
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПараметрыВыбораПолейСубконто(Форма, Суффикс, Постфикс = "", ИмяСчета, ЗаменаСубконтоНУ = Ложь)

	ПараметрыДокумента = СписокПараметровВыбораСубконто(Форма.ЭтотОбъект, Форма.ЭтотОбъект, "Субконто" + Суффикс + "%Индекс%", ИмяСчета);
	ПроцедурыБухгалтерскогоУчетаКлиентСервер.ИзменитьПараметрыВыбораПолейСубконто(Форма, Форма.ЭтотОбъект, "Субконто" + Суффикс + "%Индекс%", "Субконто" + Суффикс + "%Индекс%" + Постфикс, ПараметрыДокумента, ЗаменаСубконтоНУ);	
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовкиИДоступностьСубконто(Форма, СчетУчета, Префикс = "", Постфикс = "", СчетУчетаНУ = Неопределено, ЭтоТаблица = Ложь)

	ПоляФормы = Новый Структура("Субконто1, Субконто2, Субконто3",
		Префикс + "СубконтоДтБУ1" + Постфикс,
		Префикс + "СубконтоДтБУ2" + Постфикс,
		Префикс + "СубконтоДтБУ3" + Постфикс);
	
	ЗаголовкиПолей = Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконтоДтБУ1", "ЗаголовокСубконтоДтБУ2", "ЗаголовокСубконтоДтБУ3");
	
	ПроцедурыБухгалтерскогоУчетаКлиентСервер.ПриВыбореСчета(СчетУчета, Форма, ПоляФормы, ЗаголовкиПолей);
	
	Если НЕ СчетУчетаНУ = Неопределено Тогда
		
		Для Каждого ПолеФормы Из ПоляФормы Цикл
			
			ПоляФормы.Вставить(ПолеФормы.Ключ, СтрЗаменить(ПолеФормы.Значение, "БУ", "НУ"));
			
		КонецЦикла;
		
		Для Каждого ЗаголовоеПоля Из ЗаголовкиПолей Цикл
			
			ЗаголовкиПолей.Вставить(ЗаголовоеПоля.Ключ, СтрЗаменить(ЗаголовоеПоля.Значение, "БУ", "НУ"));
			
		КонецЦикла;
		
		ПроцедурыБухгалтерскогоУчетаКлиентСервер.ПриВыбореСчета(СчетУчетаНУ, Форма, ПоляФормы, ЗаголовкиПолей);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СписокПараметровВыбораСубконто(ДанныеОбъекта, ПараметрыОбъекта, ШаблонИмяПоляОбъекта, ИмяСчета)
	
	СписокПараметров = Новый Структура;
	Для Индекс = 1 По 3 Цикл
		ИмяПоля = СтрЗаменить(ШаблонИмяПоляОбъекта, "%Индекс%", Индекс);
		Если ТипЗнч(ПараметрыОбъекта[ИмяПоля]) = Тип("СправочникСсылка.Контрагенты") Тогда
			СписокПараметров.Вставить("Контрагент", ПараметрыОбъекта[ИмяПоля]);
		ИначеЕсли ТипЗнч(ПараметрыОбъекта[ИмяПоля]) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
			СписокПараметров.Вставить("ДоговорКонтрагента", ПараметрыОбъекта[ИмяПоля]);
		КонецЕсли;
	КонецЦикла;
	СписокПараметров.Вставить("СчетУчета", 				  ПараметрыОбъекта[ИмяСчета]);	
	СписокПараметров.Вставить("Организация", 			  ДанныеОбъекта.Организация);
	СписокПараметров.Вставить("СтруктурноеПодразделение", ДанныеОбъекта.СтруктурноеПодразделениеОтправитель);
	СписокПараметров.Вставить("ВыбиратьПодразделенияОрганизации", Истина);

	Возврат СписокПараметров; 

КонецФункции

&НаКлиенте
Процедура УстановитьСтатьюДДСВАналитикеСчета()
	
	// Если ДДС не заполнена устанавливать субконто не нужно
	Если НЕ ЗначениеЗаполнено(ЭтотОбъект.СтатьяДвиженияДенежныхСредств) Тогда
		
		Возврат;
		
	КонецЕсли;	
	
	// статья ДДС определена в аналитике счета расчетов
	СвойстваСчета = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПолучитьСвойстваСчета(ЭтотОбъект.СчетУчетаРасчетовСКонтрагентомБУ);
	
	Индекс = 1;
	Пока Индекс < 3  Цикл
	 
		Если СвойстваСчета["ВидСубконто" + Индекс] = ПредопределенноеЗначение("ПланВидовХарактеристик.ВидыСубконтоТиповые.СтатьиДвиженияДенежныхСредств") Тогда
			ЭтотОбъект["СубконтоДтБУ" + Индекс] = ЭтотОбъект.СтатьяДвиженияДенежныхСредств;
		 	ОбщегоНазначенияБККлиентСервер.ЗаменитьСубконтоНУ(ЭтотОбъект, ЭтотОбъект.СчетУчетаРасчетовСКонтрагентомБУ, ЭтотОбъект.СчетУчетаРасчетовСКонтрагентомНУ, Индекс, ЭтотОбъект["СубконтоДтБУ" + Индекс], "СубконтоДтНУ");
		Прервать;

		КонецЕсли;

		Индекс = Индекс + 1;

	КонецЦикла;

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПроверитьВладельцаСубконтоПодразделениеБУНУ(ДанныеОбъекта)
	
	ПроцедурыБухгалтерскогоУчета.ПроверитьВладельцаСубконтоПодразделение(ДанныеОбъекта, 
	                                        ДанныеОбъекта.Организация, 
	                                        Новый Структура("НазваниеСубконтоБУ1, НазваниеСубконтоБУ2, НазваниеСубконтоБУ3, 
	                                                        |СубконтоБУ1, СубконтоБУ2, СубконтоБУ3",
	                                                        "СубконтоДтБУ1", "СубконтоДтБУ2", "СубконтоДтБУ3", 
	                                                        ДанныеОбъекта.СубконтоДтБУ1, ДанныеОбъекта.СубконтоДтБУ2, ДанныеОбъекта.СубконтоДтБУ3));
															
	ПроцедурыБухгалтерскогоУчета.ПроверитьВладельцаСубконтоПодразделение(ДанныеОбъекта, 
	                                        ДанныеОбъекта.Организация, 
	                                        Новый Структура("НазваниеСубконтоБУ1, НазваниеСубконтоБУ2, НазваниеСубконтоБУ3, 
	                                                        |СубконтоБУ1, СубконтоБУ2, СубконтоБУ3",
	                                                        "СубконтоДтНУ1", "СубконтоДтНУ2", "СубконтоДтНУ3", 
	                                                        ДанныеОбъекта.СубконтоДтНУ1, ДанныеОбъекта.СубконтоДтНУ2, ДанныеОбъекта.СубконтоДтНУ3));
															
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СчетУчетаНУПриИзмененииНаСервере(ДанныеОбъекта)
	
	ПроцедурыБухгалтерскогоУчета.ПроверитьВладельцаСубконтоПодразделение(ДанныеОбъекта, 
	                                        ДанныеОбъекта.Организация, 
	                                        Новый Структура("НазваниеСубконтоБУ1, НазваниеСубконтоБУ2, НазваниеСубконтоБУ3, 
	                                                        |СубконтоБУ1, СубконтоБУ2, СубконтоБУ3",
	                                                        "СубконтоДтНУ1", "СубконтоДтНУ2", "СубконтоДтНУ3", 
	                                                        ДанныеОбъекта.СубконтоДтНУ1, ДанныеОбъекта.СубконтоДтНУ2, ДанныеОбъекта.СубконтоДтНУ3));

КонецПроцедуры

&НаКлиенте
Процедура СубконтоНачалоВыбора(Элемент, ИмяЭлементаСубконто, ИндексСубконто, ИмяЭлементаСчета, СтрокаТаблицы, СтандартнаяОбработка)	
	
	ПараметрыДокумента = СписокПараметровВыбораСубконто(ЭтотОбъект, СтрокаТаблицы, ИмяЭлементаСубконто + "%Индекс%", ИмяЭлементаСчета);
	ПроцедурыБухгалтерскогоУчетаКлиент.НачалоВыбораЗначенияСубконто(ЭтаФорма, Элемент, ИндексСубконто, СтандартнаяОбработка, ПараметрыДокумента);
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьЗначения()
	
	Для Каждого Реквизит Из ЗначенияПриОткрытии Цикл
		ИмяРеквизита = Реквизит.Ключ;
		Если ЭтаФорма[ИмяРеквизита] <> Реквизит.Значение Тогда
			Возврат Истина
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
				
КонецФункции

&НаСервере
Процедура РазблокироватьРеквизиты() Экспорт
	
	
КонецПроцедуры

&НаСервере
Функция РеквизитыЗаблокированы()
	
	Возврат ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ЭтотОбъект, "ПараметрыЗапретаРедактированияРеквизитов");
	
КонецФункции
#КонецОбласти