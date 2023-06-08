#Область ОбработчикиФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИспользоватьОбменВС = ПолучитьФункциональнуюОпцию("ИспользоватьОбменВС");
	
	Если Не ИспользоватьОбменВС Тогда
		Константы.ИспользоватьЭлектронныеСНТ.Установить(Ложь);
	Иначе
		
		ИспользоватьЭлектронныеСНТ = ПолучитьФункциональнуюОпцию("ИспользоватьЭлектронныеСНТ");
		
		ИспользуетсяРазделениеДанных = СНТСерверПереопределяемый.ИспользуетсяРазделениеДанных();
		
		Если НЕ ИспользуетсяРазделениеДанных Тогда	
			
			ИспользоватьВнешнийМодуль = Константы.СНТИспользоватьВнешнийМодульОбменаДанными.Получить();
			ДанныеМодуля = Константы.СНТВнешнийМодульОбменаДанными.Получить().Получить();
			
		КонецЕсли;
		
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьИнтерфейс();
	
	Контейнер = СНТКлиентСервер.КонтейнерМетодов();	
	Контейнер.ПриОткрытииФормы(ЭтаФорма, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	СохранитьИЗакрыть();
КонецПроцедуры

&НаКлиенте
Процедура Применить(Команда)
	Отказ = Ложь;
	СохранитьНастройки(Отказ);
	Если НЕ Отказ Тогда
		ОбновитьИнтерфейс();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Отказ = Ложь;
	СохранитьНастройки(Отказ);
	Если НЕ Отказ Тогда
		ОбновитьИнтерфейс();
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОбменСНТПриИзменении(Элемент)
	
	Модифицированность = Истина;
	УправлениеФормой(ЭтаФорма);
		
КонецПроцедуры

#КонецОбласти

#Область КомандыФормы_ВнешнийМодуль

&НаКлиенте
Процедура ИспользоватьВнешнийМодульПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
	Если ИспользоватьВнешнийМодуль И НЕ ЗначениеЗаполнено(ДанныеМодуля) Тогда
		ВыбратьВнешнийМодуль();
	ИначеЕсли НЕ ИспользоватьВнешнийМодуль Тогда
		ДанныеМодуля = Неопределено;
		Модифицированность = Истина;
		УправлениеФормой(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеМодульОбменаСНТПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьВнешнийМодуль();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеМодульОбменаСНТПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	
	ДанныеМодуля = Неопределено;
	
	Модифицированность = Истина;
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьВФайл(Команда)
	
	Если ЗначениеЗаполнено(ДанныеМодуля) Тогда
		ТекстСообщения = НСтр("ru = 'Для выгрузки внешней обработки в файл рекомендуется установить расширение для веб-клиента 1С:Предприятие.'");
		Обработчик = Новый ОписаниеОповещения("ВыгрузитьВФайлЗавершение", ЭтотОбъект);
		ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Обработчик, ТекстСообщения);
	Иначе
		ЭСФКлиентСервер.СообщитьПользователю(НСтр("ru = 'Отсутствует файл внешней обработки для сохранения.'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Форма.Элементы.ИспользоватьОбменСНТ.Доступность = Форма.ИспользоватьОбменВС;
		
	Если Не Форма.ИспользуетсяРазделениеДанных Тогда
	
		Форма.Элементы.ПолеМодульСНТПредставление.Доступность = Форма.ИспользоватьВнешнийМодуль;
		
		Если НЕ ЗначениеЗаполнено(Форма.ДанныеМодуля) Тогда
			Форма.МодульСНТПредставление = "";
		Иначе
			Форма.МодульСНТПредставление = "";
			Если НЕ ЗначениеЗаполнено(Форма.МодульСНТПредставление) И ЗначениеЗаполнено(Форма.ДанныеМодуля) Тогда
				ТекстПредставленияМодуля = НСтр("ru = 'Модуль загружен [обработка ""%1.epf""]'");
				ТекстПредставленияМодуля =
					СНТКлиентСерверПереопределяемый.ПодставитьПараметрыВСтроку(ТекстПредставленияМодуля, СНТКлиентСервер.ИмяВнешнейОбработкиОбменСНТ());
				Форма.МодульСНТПредставление = ТекстПредставленияМодуля;
			КонецЕсли;
		КонецЕсли;
		
		Форма.Элементы.ВыгрузитьВФайл.Доступность = Форма.ИспользоватьВнешнийМодуль И ЗначениеЗаполнено(Форма.ДанныеМодуля);
	Иначе
		
		Форма.Элементы.ГруппаВнешнийМодуль.Доступность = Ложь;
	
	КонецЕсли;

	Форма.Элементы.ГруппаВнешнийМодуль.Видимость = Форма.ИспользоватьЭлектронныеСНТ;
		
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВнешнийМодуль()
	
	ДанныеМодуля = Неопределено;
	
	ВыбранноеИмяФайла = "";
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьВнешнийМодульЗавершение", ЭтотОбъект);
	НачатьПомещениеФайла(ОписаниеОповещения, ДанныеМодуля, ВыбранноеИмяФайла, Истина, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВнешнийМодульЗавершение(Результат, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	ВыбранКорректныйФайл = ВыбранКорректныйФайл(ВыбранноеИмяФайла, ".epf");
	Если НЕ ВыбранКорректныйФайл Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Загружать можно только файлы с расширением *.epf'"));
	Иначе
		ДанныеМодуля = Адрес;
		ВыбратьВнешнийМодульИзменитьПеременные(Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВнешнийМодульИзменитьПеременные(ФайлыБылиВыбраны)
	
	Если ФайлыБылиВыбраны И ЗначениеЗаполнено(ДанныеМодуля) Тогда
		стрВерсияМодуля = ПолучитьВерсиюВнешнегоМодуляИзФайла(ДанныеМодуля);
		//Если стрВерсияМодуля = Неопределено Тогда
		//	ПоказатьПредупреждение(, НСтр("ru = 'Выбранный файл не является внешним модулем обмена СНТ!'"));
		//	
		//Иначе
			Модифицированность = Истина;
			УправлениеФормой(ЭтаФорма);
		//КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Функция ВыбранКорректныйФайл(Знач ПолныйПуть, Знач ПолноеИмяФайлаБезПути) Экспорт
	
	ПолныйПуть = Врег(ПолныйПуть);
	ПолноеИмяФайлаБезПути = Врег(ПолноеИмяФайлаБезПути);
	
	ДлинаПолногоИмениФайлаБезПути = СтрДлина(ПолноеИмяФайлаБезПути);
	Возврат Прав(ПолныйПуть, ДлинаПолногоИмениФайлаБезПути) = ПолноеИмяФайлаБезПути;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьВерсиюВнешнегоМодуляИзФайла(МодульДвоичныеДанные)
	
	// Сохраняем обработку во временный файл.
	Если МодульДвоичныеДанные <> Неопределено Тогда
		ИмяФайлаОбработки = ПолучитьИмяВременногоФайла("epf");
		Если ЭтоАдресВременногоХранилища(МодульДвоичныеДанные) Тогда
			ПолучитьИзВременногоХранилища(МодульДвоичныеДанные).Записать(ИмяФайлаОбработки);
		Иначе
			МодульДвоичныеДанные.Записать(ИмяФайлаОбработки);
		КонецЕсли;
	Иначе
		Возврат Неопределено
	КонецЕсли;
	
	// Пытаемся извлечь версию внешнего модуля.
	Попытка
		Результат = ВнешниеОбработки.Создать(ИмяФайлаОбработки).ВерсияБЭСФ;
	Исключение
		Результат = Неопределено;
	КонецПопытки;
	
	// Удаляем временный файл обработки.
	УдалитьФайлы(ИмяФайлаОбработки);
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещенияОЗакрытии, ТекстПредложения = "", 
	ВозможноПродолжениеБезУстановки = Истина) Экспорт
	
	ОписаниеОповещенияЗавершение = Новый ОписаниеОповещения("ПоказатьВопросОбУстановкеРасширенияРаботыСФайламиЗавершение",
		ЭтотОбъект, ОписаниеОповещенияОЗакрытии);
	
#Если Не ВебКлиент Тогда
	// В тонком и толстом клиентах расширение подключено всегда.
	ВыполнитьОбработкуОповещения(ОписаниеОповещенияЗавершение, "ПодключениеНеТребуется");
	Возврат;
#КонецЕсли
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОписаниеОповещенияЗавершение", ОписаниеОповещенияЗавершение);
	ДополнительныеПараметры.Вставить("ТекстПредложения", ТекстПредложения);
	ДополнительныеПараметры.Вставить("ВозможноПродолжениеБезУстановки", ВозможноПродолжениеБезУстановки);
	
	Оповещение = Новый ОписаниеОповещения("ПоказатьВопросОбУстановкеРасширенияРаботыСФайламиПриУстановкеРасширения",
		ЭтотОбъект, ДополнительныеПараметры);
	НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВопросОбУстановкеРасширенияРаботыСФайламиЗавершение(Действие, ОповещениеОЗакрытии) Экспорт
	
	РасширениеПодключено = (Действие = "РасширениеПодключено" Или Действие = "ПодключениеНеТребуется");
#Если ВебКлиент Тогда
	Если Действие = "БольшеНеПредлагать"
		Или Действие = "РасширениеПодключено" Тогда
		СистемнаяИнформация = Новый СистемнаяИнформация();
		ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
		ПараметрыПриложения["СтандартныеПодсистемы.ПредлагатьУстановкуРасширенияРаботыСФайлами"] = Ложь;
		ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
			"НастройкиПрограммы/ПредлагатьУстановкуРасширенияРаботыСФайлами", ИдентификаторКлиента, Ложь);
	КонецЕсли;
#КонецЕсли
	
	ВыполнитьОбработкуОповещения(ОповещениеОЗакрытии, РасширениеПодключено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВопросОбУстановкеРасширенияРаботыСФайламиПриУстановкеРасширения(Подключено, ДополнительныеПараметры) Экспорт
	
	// Если расширение и так уже подключено, незачем про него спрашивать.
	Если Подключено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещенияЗавершение, "ПодключениеНеТребуется");
		Возврат;
	КонецЕсли;
	
	// В веб клиенте под MacOS расширение не доступно.
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ЭтоMacКлиент = (СистемнаяИнформация.ТипПлатформы = ТипПлатформы.MacOS_x86
		Или СистемнаяИнформация.ТипПлатформы = ТипПлатформы.MacOS_x86_64);
	Если ЭтоMacКлиент Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещенияЗавершение);
		Возврат;
	КонецЕсли;
	
	ИмяПараметра = "СтандартныеПодсистемы.ПредлагатьУстановкуРасширенияРаботыСФайлами";
	ПервоеОбращениеЗаСеанс = ПараметрыПриложения[ИмяПараметра] = Неопределено;
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, ОбщегоНазначенияКлиент.ПредлагатьУстановкуРасширенияРаботыСФайлами());
	КонецЕсли;
	ПредлагатьУстановкуРасширенияРаботыСФайлами	= ПараметрыПриложения[ИмяПараметра] Или ПервоеОбращениеЗаСеанс;
	
	Если ДополнительныеПараметры.ВозможноПродолжениеБезУстановки И Не ПредлагатьУстановкуРасширенияРаботыСФайлами Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещенияЗавершение);
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекстПредложения", ДополнительныеПараметры.ТекстПредложения);
	ПараметрыФормы.Вставить("ВозможноПродолжениеБезУстановки", ДополнительныеПараметры.ВозможноПродолжениеБезУстановки);
	ОткрытьФорму("ОбщаяФорма.ВопросОбУстановкеРасширенияРаботыСФайлами", ПараметрыФормы,,,,,ДополнительныеПараметры.ОписаниеОповещенияЗавершение);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьВФайлЗавершение(Подключено, ПараметрыВыгрузки) Экспорт
	
	Перем Адрес;
	
	Если ТипЗнч(ДанныеМодуля) = Тип("ДвоичныеДанные") Тогда
		Адрес = ПоместитьВоВременноеХранилище(ДанныеМодуля, Неопределено);
	ИначеЕсли ЭтоАдресВременногоХранилища(ДанныеМодуля) Тогда
		Адрес = ДанныеМодуля;
	КонецЕсли;
	
	ИмяФайла = СНТКлиентСервер.ИмяВнешнейОбработкиОбменСНТ();
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Адрес", Адрес);
	
	Если Не Подключено Тогда
		ПолучитьФайл(Адрес, ИмяФайла, Истина);
		Возврат;
	КонецЕсли;
	
	ДиалогСохраненияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	ДиалогСохраненияФайла.ПолноеИмяФайла = ИмяФайла;
	ДиалогСохраненияФайла.Фильтр = НСтр("ru = 'Внешние обработки (*.epf)|*.epf'");
	ДиалогСохраненияФайла.ИндексФильтра = 1;
	ДиалогСохраненияФайла.МножественныйВыбор = Ложь;
	ДиалогСохраненияФайла.Заголовок = НСтр("ru = 'Укажите файл'");
	
	Обработчик = Новый ОписаниеОповещения("ВыгрузитьФайлВыборФайла", ЭтотОбъект, ДополнительныеПараметры);
	ДиалогСохраненияФайла.Показать(Обработчик);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьФайлВыборФайла(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено Тогда
		ПолноеИмяФайла = ВыбранныеФайлы[0];
		ПолучаемыеФайлы = Новый Массив;
		ПолучаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(ПолноеИмяФайла, ДополнительныеПараметры.Адрес));
		
		Обработчик = Новый ОписаниеОповещения("ОбработкаРезультатаНеТребуется", ЭтотОбъект);
		НачатьПолучениеФайлов(Обработчик, ПолучаемыеФайлы, ПолноеИмяФайла, Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаРезультатаНеТребуется(ПолученныеФайлы, ДополнительныеПараметры) Экспорт
	Возврат;
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки(Отказ = Ложь)
	
	Если Модифицированность И ПроверитьЗаполнение() Тогда		
		
		Если НЕ ИспользуетсяРазделениеДанных Тогда
			Если ИспользоватьВнешнийМодуль И НЕ ЗначениеЗаполнено(ДанныеМодуля) Тогда
				ЭСФКлиентСервер.СообщитьПользователю(НСтр("ru = 'Выберите внешний модуль.'"));
				Отказ = Истина;
				Возврат;
			КонецЕсли;
			
			// сохраняем общие настройки
			КонстантыНабор = Константы.СоздатьНабор("СНТИспользоватьВнешнийМодульОбменаДанными,
			|СНТВнешнийМодульОбменаДанными");
			КонстантыНабор.СНТИспользоватьВнешнийМодульОбменаДанными = ИспользоватьВнешнийМодуль;
			
			Если ЗначениеЗаполнено(ДанныеМодуля) Тогда
				Если ТипЗнч(ДанныеМодуля) = Тип("ДвоичныеДанные") Тогда
					КонстантыНабор.СНТВнешнийМодульОбменаДанными = Новый ХранилищеЗначения(ДанныеМодуля);
				ИначеЕсли ЭтоАдресВременногоХранилища(ДанныеМодуля) Тогда
					ДанныеМодуля = ПолучитьИзВременногоХранилища(ДанныеМодуля);
					КонстантыНабор.СНТВнешнийМодульОбменаДанными = Новый ХранилищеЗначения(ДанныеМодуля);
				КонецЕсли;
			Иначе
				КонстантыНабор.СНТВнешнийМодульОбменаДанными = Неопределено;
			КонецЕсли;
			
			КонстантыНабор.Записать();
		КонецЕсли;	
		
		УстановитьКонстантуИспользоватьЭлектронныеСНТ(ИспользоватьЭлектронныеСНТ);
		
		Модифицированность = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьКонстантуИспользоватьЭлектронныеСНТ(ИспользоватьЭлектронныеСНТ)
	
	Константы.ИспользоватьЭлектронныеСНТ.Установить(ИспользоватьЭлектронныеСНТ);	
	
КонецПроцедуры

#КонецОбласти