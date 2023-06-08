
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Документы.ЧекККМ);
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	Элементы.ФормаИзменитьВыделенные.Видимость = МожноРедактировать;
	
	Элементы.РозничнаяПродажа.Доступность   = ПравоДоступа("Добавление", Метаданные.Документы.ЧекККМ);
	Элементы.ФормаВозвратПоЧеку.Доступность = ПравоДоступа("Добавление", Метаданные.Документы.ЧекККМ);
	Элементы.ЗакрытьСмену.Доступность       = ПравоДоступа("Добавление", Метаданные.Документы.ОтчетОРозничныхПродажах);
	
	ЕстьПравоДобавленияВозвратОтПокупателя = ПравоДоступа("Добавление", Метаданные.Документы.ВозвратТоваровОтПокупателя);
	
	ИспользуетсяНесколькоОрганизаций = Справочники.Организации.КоличествоОрганизаций() > 1;
	
	// ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	ИдентификаторыСобытийПриОткрытии = Новый Массив;
	ИдентификаторыСобытийПриОткрытии.Добавить("ПриОткрытии");
	
	// патенты, возможно только для БП
	ИмеютсяДействующиеПатенты = Ложь; //УчетПСН.ИмеютсяДействующиеПатенты(ТекущаяДатаСеанса());
	Если ИмеютсяДействующиеПатенты Тогда
		ИдентификаторыСобытийПриОткрытии.Добавить("ПриОткрытии_ИспользуетсяПатент");
	КонецЕсли;
	
	////ОбработкаНовостейПереопределяемый.КонтекстныеНовости_ПриСозданииНаСервере(
	////	ЭтаФорма,
	////	"БП.Документ.РозничнаяПродажа",
	////	"ФормаСписка",
	////	НСтр("ru='Новости: Розничная продажа (чек)'"),
	////	ИдентификаторыСобытийПриОткрытии
	////);
	//// Конец ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	
	АдресХранилищаНастройкиДинСпискаДляРеестра = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	
	ОбщегоНазначенияБКВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтотОбъект);
	
	ОбщегоНазначенияБК.ФормаСпискаПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		ОбщегоНазначенияБККлиент.ИзменитьОтборПоОсновнойОрганизации(Список, ,Параметр);
	ИначеЕсли ИмяСобытия = "КассовыеСменыКлиентБП.СобытиеВыполняетсяОперацияКассовойСмены()" Тогда
		Доступность = Ложь;
	ИначеЕсли ИмяСобытия = "КассовыеСменыКлиентБП.СобытиеЗавершиласьОперацияКассовойСмены()" Тогда
		Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РозничнаяПродажа(Команда)
	
	КлючеваяОперация = "СозданиеФормыРозничнаяПродажа";
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);

	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийРозничнаяПродажа.Продажа"));
		
	ОткрытьФорму("Документ.ЧекККМ.ФормаОбъекта", СтруктураПараметров, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВидОперации(Команда)
	
	СтрокаТаблицы = Элементы.Список.ТекущиеДанные;
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Ключ", СтрокаТаблицы.Ссылка);
	ПараметрыФормы.Вставить("ВидОперации", СтрокаТаблицы.ВидОперации);
	ПараметрыФормы.Вставить("ИзменитьВидОперации", Истина);
	
	ОткрытьФорму("Документ.ЧекККМ.Форма.ФормаДокумента", ПараметрыФормы, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);

КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьСмену(Команда)
	
	// закрытие смены
	ЗакрытьКассовуюСмену(УникальныйИдентификатор, Список.КомпоновщикНастроек);
	
КонецПроцедуры

&НаКлиенте
Процедура ВозвратПоЧеку(Команда)
	
	ТекущаяСтрока = Элементы.Список.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущаяСтрока.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРозничнаяПродажа.Возврат") Тогда
		ВызватьИсключение НСтр("ru = 'Оформление возврата по чеку с видом операции ""Возврат"" невозможен.'");
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	ЗначенияЗаполнения  = Новый Структура;
	
	ЗначенияЗаполнения.Вставить("ВидОперации", ПредопределенноеЗначение("Перечисление.ВидыОперацийРозничнаяПродажа.Возврат"));
	ЗначенияЗаполнения.Вставить("Основание",   ТекущаяСтрока.Ссылка);
	
	СтруктураПараметров.Вставить("ЗначенияЗаполнения",  ЗначенияЗаполнения);
	СтруктураПараметров.Вставить("ИзменитьВидОперации", Истина);
	
	Если НЕ РазрешитьВовзратПоЧеку(ТекущаяСтрока.Ссылка) Тогда
		ОткрытьФорму("Документ.ВозвратТоваровОтПокупателя.Форма.ФормаДокумента", СтруктураПараметров, ЭтотОбъект, ТекущаяСтрока.Ссылка);
	Иначе
		ОткрытьФорму("Документ.ЧекККМ.Форма.ФормаДокумента", СтруктураПараметров, ЭтотОбъект, ТекущаяСтрока.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция РазрешитьВовзратПоЧеку(ЧекНаВозврат)
	
	Запрос = Новый Запрос;
	Запрос.Текст =  "ВЫБРАТЬ
	|	ЧекККМ.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ЧекККМ КАК ЧекККМ
	|ГДЕ
	|	ЧекККМ.Ссылка = &Ссылка
	|	И ЧекККМ.ОтчетОРозничныхПродажах = ЗНАЧЕНИЕ(Документ.ОтчетОРозничныхПродажах.ПустаяСсылка)";
	
	Запрос.УстановитьПараметр("Ссылка", ЧекНаВозврат);
	Результат = Запрос.Выполнить();
	
	Возврат Не Результат.Пустой();
	
КонецФункции

&НаКлиенте
Процедура ОткрытьСмену(Команда)
	
	ПоддерживаемыеТипыВО = Новый Массив();
	ПоддерживаемыеТипыВО.Добавить("ФискальныйРегистратор");
	ПоддерживаемыеТипыВО.Добавить("ПринтерЧеков");
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьСменуПослеВыбораУстройства", ЭтотОбъект);
	МенеджерОборудованияКлиент.ПредложитьВыбратьУстройство(ОписаниеОповещения, ПоддерживаемыеТипыВО,
		НСтр("ru='Выберите фискальное устройство'"), 
		НСтр("ru='Фискальное устройство не подключено.'"), 
		НСтр("ru='Фискальное устройство не выбрано.'"), 
		Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыСписок

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	ОбщегоНазначенияБККлиентСервер.ВосстановитьОтборСписка(Список, Настройки, "Организация");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)

	КлючеваяОперация = "ОткрытиеФормыРозничнаяПродажа";
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПолучитьСтруктуруПараметровФормы(ВидОперации)

	СтруктураПараметров = Новый Структура;
	
	ЗначенияЗаполнения = ОбщегоНазначенияБКВызовСервера.ЗначенияЗаполненияДинамическогоСписка(Список.КомпоновщикНастроек);
	Если ЗначениеЗаполнено(ВидОперации) Тогда
		ЗначенияЗаполнения.Вставить("ВидОперации", ВидОперации);
	КонецЕсли;
	
	СтруктураПараметров.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	Возврат СтруктураПараметров;
	
КонецФункции

// Процедура показывает новости, требующие прочтения (важные и очень важные)
//
// Параметры:
//  Нет
//
&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()

	// ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
	ИдентификаторыСобытийПриОткрытии = Новый Массив;
	ИдентификаторыСобытийПриОткрытии.Добавить("ПриОткрытии");
	
	Если ИмеютсяДействующиеПатенты Тогда
		ИдентификаторыСобытийПриОткрытии.Добавить("ПриОткрытии_ИспользуетсяПатент");
	КонецЕсли;
	// Конец ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии

	ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтаФорма, ИдентификаторыСобытийПриОткрытии);

КонецПроцедуры


#Область КассовыеСмены

// Формирует документы "ОтчетОРозничныхПродажах", а также на кассовом аппарате закрывает
// смену и формирует отчет о закрытии смены (Z-отчет)
//
// Параметры:
//  КлючФормы - УникальныйИдентификатор - уникальный идентификатор формы, из которой вызывается операция закрытия смены
//  КомпоновщикНастроек - КомпоновщикНастроекКомпоновкиДанных - передается из формы при вызове операции закрытия смены,
//                        значения отборов из данного компоновщика могут использоваться в качестве значений по-умолчанию
//                        во время выполнения операции
//
&НаКлиенте
Процедура ЗакрытьКассовуюСмену(КлючФормы, Знач КомпоновщикНастроек) Экспорт
	
	Если МенеджерОборудованияКлиент.ОбновитьРабочееМестоКлиента() Тогда
		РабочееМесто = МенеджерОборудованияКлиентПовтИсп.ПолучитьРабочееМестоКлиента();
	Иначе
		РабочееМесто = Неопределено;
	КонецЕсли;
	
	ДанныеЗакрытия = ДанныеЗакрытияКассовойСмены(РабочееМесто, КлючФормы, КомпоновщикНастроек);
		
	Если Не ЗначениеЗаполнено(ДанныеЗакрытия.ОткрытыеСмены) Тогда
		Возврат;
	ИначеЕсли ДанныеЗакрытия.ОткрытыеСмены.Количество() = 1 Тогда
		ЗакрытьСменуЗавершение(ДанныеЗакрытия.ОткрытыеСмены[0], ДанныеЗакрытия);
	Иначе
		// Если найдено несколько открытых смен, пользователю предлагается выбрать организацию и
		// кассовое устройство, чтобы по этим параметрам определить, какую смену необходимо закрыть
		//
		ОповещениеПриЗавершении = Новый ОписаниеОповещения("ЗакрытьСменуЗавершение", ЭтотОбъект, ДанныеЗакрытия);
		ОткрытьФорму("Документ.ЧекККМ.Форма.ФормаЗакрытиеСмены", ДанныеЗакрытия, , , , ,
			ОповещениеПриЗавершении, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает данные, необходимые для выполнения операции закрытия кассовой смены
//
// Параметры:
//  РабочееМесто - СправочникСсылка.РабочиеМеста, Неопределено - рабочее место, для которого выполняется операция
//                 закрытия смены, может принимать значение Неопределено, если отсутствует подключаемое оборудование
//  КлючФормы - УникальныйИдентификатор - см. НовыеДанныеЗакрытияКассовойСмены
//  КомпоновщикНастроек - КомпоновщикНастроекКомпоновкиДанных - в случае интерактивного вызова операции закрытия смены
//                        с вызывающей формы передается КомпоновщикНастроек, используемый для возможной подстановки значений
//                        из настроенных на форме отборов
//
// Возвращаемое значение:
//  Структура - входящие параметры для операции закрытия кассовой смены, см. НовыеДанныеЗакрытияКассовойСмены
//
&НаСервере
Функция ДанныеЗакрытияКассовойСмены(РабочееМесто, КлючФормы, КомпоновщикНастроек) Экспорт
	
	ДанныеЗакрытия = НовыеДанныеЗакрытияКассовойСмены();
	
	ДанныеЗакрытия.ОткрытыеСмены = ОткрытыеСменыСервер(РабочееМесто);
	ДанныеЗакрытия.КлючФормы = КлючФормы;
	
	КоличествоОткрытыхСмен = ДанныеЗакрытия.ОткрытыеСмены.Количество();
	Если КоличествоОткрытыхСмен = 1
		Или (КоличествоОткрытыхСмен > 0) Тогда
		// Если открытые смены есть только по одной организации, то сразу используем ее в качестве организации по-умолчанию и
		// определим данные кассира
		Организация = ДанныеЗакрытия.ОткрытыеСмены[0].Организация;
		
		ДанныеКассира = ОбщегоНазначенияБКВызовСервера.ДанныеФизЛицаТекущегоПользователя(Организация);
		Если ДанныеКассира.Представление <> Неопределено Тогда
			Кассир = СтрШаблон(НСтр("ru = '%1 %2'"), Строка(ДанныеКассира.Должность), ДанныеКассира.Представление);
		Иначе
			Кассир = НСтр("ru = 'Администратор'");
		КонецЕсли;
		
		ДанныеЗакрытия.Кассир = Кассир;
		ДанныеЗакрытия.Организация = Организация;
	Иначе
		// Если в форме, из которой происходит вызов операции закрытия кассовой смены, установлен отбор по организации,
		// то используем значение отбора для организации по-умолчанию
		ЗначенияЗаполнения = ОбщегоНазначенияБКВызовСервера.ЗначенияЗаполненияДинамическогоСписка(КомпоновщикНастроек);
		Если ЗначенияЗаполнения.Свойство("Организация") Тогда
			ДанныеЗакрытия.Организация = ЗначенияЗаполнения.Организация;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ДанныеЗакрытия;
	
КонецФункции

&НаСервере
Функция НовыеДанныеЗакрытияКассовойСмены()
	
	ДанныеЗакрытия = Новый Структура;
	ДанныеЗакрытия.Вставить("Организация",   Справочники.Организации.ПустаяСсылка()); // организация,
	                                                                     // используемая по-умолчанию
	ДанныеЗакрытия.Вставить("ОткрытыеСмены", Новый Массив); // для каждой открытой кассовой смены массив содержит
	                                                        // структуру со следующими свойствами:
	                                         // * Организация - СправочникСсылка.Организация - организация открытой
                                             //                 кассовой смены
	                                         // * ИдентификаторУстройства - СправочникСсылка.ПодключаемоеОборудование - 
	                                         //                 ссылка на экземпляр подключаемого оборудования, к которому
	                                         //                 относится открытая кассовая смена
	ДанныеЗакрытия.Вставить("Кассир",        ""); // информация о кассире, которая выводится в кассовые документы
	ДанныеЗакрытия.Вставить("КлючФормы",     Новый УникальныйИдентификатор); // уникальный идентификатор формы,
	                                         // из которой произошел вызов операции закрытия кассовой смены
	Возврат ДанныеЗакрытия;
	
КонецФункции

&НаСервереБезКонтекста
Функция ОткрытыеСменыСервер(РабочееМесто)
	
	// Возможен сценарий работы, при котором пользователь, не подключая кассу, пробивает продажи отдельными
	// чеками и формирует на их основании отчеты о розничных продажах, используя операцию закрытия кассовой смены.
	// Поскольку в описаном сценарии документ "Кассовая смена" не формируется (т.к. кассовое устройство по факту
	// отсутствует) происходит обращение непосредственно к чекам (документ "Розничная продажа") и в этом случае
	// чеки могут отбираться за любой период. Основным условием отбора является отбор по реквизиту
	// "ОтчетОРозничныхПродажах", этот реквизит входит в состав критерия отбора "СвязанныеДокументы", поэтому его
	// не требуется дополнительно индексировать
	//
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	КассоваяСмена.ФискальноеУстройство КАК ИдентификаторУстройства,
	|	КассоваяСмена.Организация КАК Организация
	|ИЗ
	|	Документ.КассоваяСмена КАК КассоваяСмена
	|ГДЕ
	|	КассоваяСмена.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыКассовойСмены.Открыта)
	|	И КассоваяСмена.ФискальноеУстройство.РабочееМесто = &РабочееМесто
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ЧекККМ.ИдентификаторУстройства,
	|	ЧекККМ.Организация
	|ИЗ
	|	Документ.ЧекККМ КАК ЧекККМ
	|ГДЕ
	|	ЧекККМ.ОтчетОРозничныхПродажах = ЗНАЧЕНИЕ(Документ.ОтчетОРозничныхПродажах.ПустаяСсылка)
	|	И ЧекККМ.Проведен
	|	И ЧекККМ.ИдентификаторУстройства = ЗНАЧЕНИЕ(Справочник.ПодключаемоеОборудование.ПустаяСсылка)";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("РабочееМесто", РабочееМесто);
	
	// Массив структур используется для совместимости с процедурой "ЗакрытьСмену", общего модуля
	// "КассовыеСменыКлиентБП", а также для передачи его в качестве параметра в форму "ФормаЗакрытиеСмены"
	// документа "РозничнаяПродажа"
	//
	Возврат ОбщегоНазначения.ТаблицаЗначенийВМассив(Запрос.Выполнить().Выгрузить());
	
КонецФункции

// Продолжение операции закрытия кассовой смены, вызывается после того как пользователь выбрал значения
// реквизитов, по которым можно определить какую именно кассовую смену требуется закрыть (или эти значения
// определены автоматически, в том случае, когда открытая кассовая смена всего одна)
//
// Параметры:
//  Результат - Структура, Неопределено - содержит следующие свойства, по которым будет определена кассовая смена для
//                                        выполнения операции закрытия:
//                                        * Организация
//                                        * ИдентификаторУстройства
//                                       принимает значение Неопределено если пользователь отказался выбирать реквизиты
//  ДанныеЗакрытия - Структура - содержит параметры операции закрытия кассовой смены.
//                               Подробнее см. КассовыеСменыВызовСервераБП.НовыеДанныеЗакрытияКассовойСмены
//
&НаКлиенте
Процедура ЗакрытьСменуЗавершение(Результат, ДанныеЗакрытия) Экспорт
	
	// Если в форме закрытия смены пользователь нажал "Отмена"
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Результат.ИдентификаторУстройства) Тогда
		ПараметрыОперации = МенеджерОборудованияКлиентСервер.ПараметрыОткрытияЗакрытияСмены();
		Если ЗначениеЗаполнено(ДанныеЗакрытия.Кассир) Тогда
			ПараметрыОперации.Кассир = ДанныеЗакрытия.Кассир;
		Иначе
			ДанныеКассира = ОбщегоНазначенияБКВызовСервера.ДанныеФизЛицаТекущегоПользователя(Результат.Организация);
			Если ДанныеКассира.Представление <> Неопределено Тогда
				Кассир = СтрШаблон(НСтр("ru = '%1 %2'"), Строка(ДанныеКассира.Должность), ДанныеКассира.Представление);
			Иначе
				Кассир = НСтр("ru = 'Администратор'");
			КонецЕсли;
			ПараметрыОперации.Кассир = Кассир;
		КонецЕсли;
		Оповестить("ВыполняетсяОперацияБлокирующаяКассовуюСмену");
		ДанныеЗакрытия.Организация = Результат.Организация;
		ОповещениеПриЗавершении = Новый ОписаниеОповещения("ПечатьФискальногоОтчетаЗавершение", ЭтотОбъект, ДанныеЗакрытия);
		МенеджерОборудованияКлиент.НачатьЗакрытиеСменыНаФискальномУстройстве(ОповещениеПриЗавершении, ДанныеЗакрытия.КлючФормы,
			ПараметрыОперации, Результат.ИдентификаторУстройства);
	Иначе
		// В форме закрытия кассовой смены пользователь не выбрал кассовое утройство. В этом случае пропускаем операции взаимодействия
		// с драйвером кассового аппарата и переходим к следующему шагу - созданию отчетов о розничных продажах на основании документов
		// "РозничнаяПродажа" (чеков), сформированных без подключения кассы
		//
		ДанныеЗакрытия.Организация = Результат.Организация;
		
		РеквизитыПропущеннойОперации = Новый Структура;
		РеквизитыПропущеннойОперации.Вставить("Результат", Истина);
		РеквизитыПропущеннойОперации.Вставить("ИдентификаторУстройства", 
			ПредопределенноеЗначение("Справочник.ПодключаемоеОборудование.ПустаяСсылка"));
		ПечатьФискальногоОтчетаЗавершение(РеквизитыПропущеннойОперации, ДанныеЗакрытия);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьФискальногоОтчетаЗавершение(РезультатВыполнения, ДанныеЗакрытия) Экспорт
	
	Оповестить("ЗавершенаОперацияБлокирующаяКассовуюСмену");
	Если Не РезультатВыполнения.Результат Тогда
		ТекстСообщения = СтрШаблон(НСтр("ru = 'При формировании отчета произошла ошибка:""%1"".'"),
			РезультатВыполнения.ОписаниеОшибки);
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	Иначе 
		СозданныеДокументы = СформироватьОтчетыОРозничныхПродажах(ДанныеЗакрытия.Организация,
			РезультатВыполнения.ИдентификаторУстройства);
		Если СозданныеДокументы.Количество() > 0 Тогда
			ТекстОповещения = СтрШаблон(НСтр("ru = 'Сформировано документов: %1'"), СозданныеДокументы.Количество());
			ПоказатьОповещениеПользователя("Формирование отчетов о розничных продажах", , ТекстОповещения);
		КонецЕсли;
		ОповеститьОбИзменении(Тип("ДокументСсылка.ЧекККМ"));
		ОповеститьОбИзменении(Тип("ДокументСсылка.ОтчетОРозничныхПродажах"));
		//ВызватьОповещенияПриИзмененииСтатусаКассовойСмены();
		Оповестить("ОбновитьБаннеры_РозничнаяТорговля");
		Оповестить("ИзменениеСтатусаКассовойСмены");
	КонецЕсли;
	
КонецПроцедуры

// Функция - Сформировать отчеты о розничных продажах
//
// Параметры:
//  Организация - СправочникСсылка.Организации - в формируемые отчеты о розничных продажах попадут чеки с установленным
//                                               отбором по данной организации
//  ИдентификаторУстройства - СправочникСсылка.ПодключаемоеОборудование - кассовое устройство по которому будет установлен отбор
//                                                                        на чеки, попадающие в формируемые отчеты о розничных продажах
//
// Возвращаемое значение:
//  Массив - Созданные отчеты о розничных продажах (ДокументСсылка.ОтчетОРозничныхПродажах)
//
&НаСервере
Функция СформироватьОтчетыОРозничныхПродажах(Организация, ИдентификаторУстройства) Экспорт

	Возврат Документы.ЧекККМ.СформироватьОтчетыОРозничныхПродажах(Организация, ИдентификаторУстройства);

КонецФункции

&НаКлиенте
Процедура ОткрытьСменуПослеВыбораУстройства(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтатусПоследнейСмены = МенеджерОборудованияВызовСервера.ПолучитьСтатусПоследнейСмены(Результат);	
	
	Если  СтатусПоследнейСмены.Активна Тогда
		
		ОчиститьСообщения();
		
		ТекстСообщения = НСтр("ru = 'Для открытия следующей кассовой смены закройте текущую: %КассоваяСмена%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%КассоваяСмена%", СтатусПоследнейСмены.КассоваяСмена);
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ТекстСообщения;
		Сообщение.КлючДанных = СтатусПоследнейСмены.КассоваяСмена;
		Сообщение.Сообщить();
		
	Иначе
		
		ПараметрыОперации = МенеджерОборудованияКлиентСервер.ПараметрыВыполненияОперации();
		
		Кассир = "";
		ВыполненаСтандартнаяОбработка = Истина;
		МенеджерОборудованияКлиентСерверПереопределяемый.ОбработкаЗаполненияИмяКассира(Кассир, ВыполненаСтандартнаяОбработка); 
		ПараметрКассир = ?(Не ВыполненаСтандартнаяОбработка, Кассир, НСтр("ru='Администратор'")); 
		
		КассирИНН = "";
		ВыполненаСтандартнаяОбработка = Истина;
		МенеджерОборудованияКлиентСерверПереопределяемый.ОбработкаЗаполненияИННКассира(КассирИНН, ВыполненаСтандартнаяОбработка); 
		ПараметрКассирИНН = ?(Не ВыполненаСтандартнаяОбработка, КассирИНН, "");
		
		ПараметрыОперации.Кассир = ПараметрКассир; 
		ПараметрыОперации.КассирИНН = ПараметрКассирИНН;
		
		ДополнительныеПараметры = Новый Структура();
		Если МенеджерОборудованияКлиентПовтИсп.ИспользуетсяПодсистемыФискальныхУстройств() Тогда
			МодульКассовыеСменыКлиентПереопределяемый = МенеджерОборудованияКлиентПовтИсп.ОбщийМодуль("КассовыеСменыКлиентПереопределяемый");
			МодульКассовыеСменыКлиентПереопределяемый.УправлениеФУЗаполнитьДополнительныеПараметрыПередОткрытиемСмены(Результат, ДополнительныеПараметры);
		КонецЕсли;
		
		ОповещениеПриЗавершении = Новый ОписаниеОповещения("ОперацияОткрытияСменыЗавершение", ЭтотОбъект);
		МенеджерОборудованияКлиент.НачатьОткрытиеСменыНаФискальномУстройстве(ОповещениеПриЗавершении, УникальныйИдентификатор, ПараметрыОперации, Результат,, ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацияОткрытияСменыЗавершение(РезультатВыполнения, Параметры) Экспорт
		
	ТекстСообщения = ?(РезультатВыполнения.Результат, НСтр("ru='Смена открыта.'"), РезультатВыполнения.ОписаниеОшибки);
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ БСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
     ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
     ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры
 
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
     ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры
 
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
     ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти 
