&НаКлиенте
Перем лкРезультат;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей") Тогда
		ТекстИсключения = НСтр("ru='Формирование отчета ""Досье контрагента"" в данной конфигурации невозможно.'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.Контрагент) Тогда
		ИННКонтрагента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Контрагент, "ИдентификационныйКодЛичности");
		Если ЗначениеЗаполнено(ИННКонтрагента) Тогда
			СтрокаПоиска = ИННКонтрагента;
			Контрагент   = Параметры.Контрагент;
		КонецЕсли;
	ИначеЕсли ЗначениеЗаполнено(Параметры.БИН) Тогда
		СтрокаПоиска = Параметры.БИН;
	КонецЕсли;
	
	ТипДанных = Элементы.ТипДанных.СписокВыбора.НайтиПоЗначению(ТипДанныхБИН()).Значение;
			
КонецПроцедуры

&НаСервере
Функция ЗаполнитьРеквизитыПоДаннымКГДНаСервере(Параметр)
	
	serviceNick = "1C-Kontragent-KZ";	
	
	РезультатПолученияТикета = КонтрагентыФормыВызовСервера.ПолучитьТикет(serviceNick);
	
	Если ТипЗнч(РезультатПолученияТикета) = Тип("Строка") Тогда 
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(РезультатПолученияТикета);

	Иначе
		
		Если ТипДанных = ТипДанныхНаименование() И ДанныеЗапросаПоНаименованию.Количество() > 0 Тогда
			СтрокаЗапроса = БинПоНаименованию();
		Иначе
			СтрокаЗапроса = ЭтаФорма.СтрокаПоиска;
		КонецЕсли;
		лкОтвет = КонтрагентыФормыВызовСервера.РезультатЗапросаСервиса(РезультатПолученияТикета.Тикет, serviceNick, СтрокаЗапроса, Параметр);
		РезультатОбщиеДанные.Очистить();
	КонецЕсли;
	
	Возврат лкОтвет;
	
КонецФункции 

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	ТекстСообщения = "";
	
	Если НЕ ЗначениеЗаполнено(СтрокаПоиска) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			?(ТипДанных = ТипДанныхБИН(),НСтр("ru='Поле ""БИН / ИИН контрагента"" не заполнено'"),НСтр("ru='Поле ""Наименование контрагента"" не заполнено'")), , "СтрокаПоиска");
		Возврат;
		
	КонецЕсли;
	
	Если ТипДанных = ТипДанныхБИН() Тогда
		Если Не РегламентированныеДанныеКлиентСервер.ИИНБИНСоответствуетТребованиям(СтрокаПоиска, ТекстСообщения) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат;
			
		КонецЕсли;
	КонецЕсли;
	
	Если ТипДанных = ТипДанныхНаименование() Тогда
		
		Если ЗначениеЗаполнено(Элементы.СтрокаПоиска.ТекстРедактирования)
			И ЗначениеЗаполнено(Элементы.СтрокаПоиска.СписокВыбора) 
			И Элементы.СтрокаПоиска.СписокВыбора.НайтиПоЗначению(Элементы.СтрокаПоиска.ТекстРедактирования) = Неопределено Тогда
			
			Возврат;
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Элементы.СтрокаПоиска.СписокВыбора) Тогда
			Параметр = "List";
		Иначе
			Параметр = "orgReport";
		КонецЕсли;
		
	Иначе
		Параметр = "orgReport";
	КонецЕсли;
	
	лкРезультат = ЗаполнитьРеквизитыПоДаннымКГДНаСервере(Параметр);
	
	ЭтаФорма.Элементы.ДекорацияБлагонадежность.ЦветТекста 		   = WebЦвета.Черный;
	ЭтаФорма.Элементы.ДекорацияНалоговыеОтчисления.ЦветТекста 	   = WebЦвета.Черный;
	ЭтаФорма.Элементы.ДекорацияДополнительнаяИнформация.ЦветТекста = WebЦвета.Черный;
	ЭтаФорма.Элементы.ДекорацияОбщиеДанные.ЦветТекста 			   = WebЦвета.Красный;
	ЭтаФорма.Элементы.СохранитьОтчет.Доступность 				   = Ложь;
	ЭтаФорма.Элементы.ДобавитьВСправочник.Доступность 			   = Ложь;
	
	Если лкРезультат <> Неопределено Тогда
		
		Если ТипЗнч(лкРезультат) = Тип("Строка") Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(лкРезультат);
		Иначе
			
			Если лкРезультат.result Тогда
				
				Если лкРезультат.Свойство("listName") Тогда // Формируем список найденных совпадений по наименованию
					Если лкРезультат.listName.Количество() = 0 Тогда
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Совпадений не найдено!'"));
					Иначе
						ЗаполнитьТаблицуСоответствий(лкРезультат.listName);
						СформироватьСписокДляВыбора();
					КонецЕсли;
				Иначе
					НайденныйИНН = лкРезультат.commonOrgData.bin;
					ПолучитьМакетНаСервере(лкРезультат, "ОбщиеДанные");
					
					ЭтаФорма.Элементы.СохранитьОтчет.Доступность      = Истина;
					ЭтаФорма.Элементы.ДобавитьВСправочник.Доступность = Истина;
				КонецЕсли;
				
			Иначе
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(лкРезультат.errorMsg);
			КонецЕсли; 
			
		КонецЕсли;
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВСправочник(Команда)
	
	СвойстваКонтрагентов = Новый Структура;
	СвойстваКонтрагентов.Вставить("Имя", "Контрагенты");
	СвойстваКонтрагентов.Вставить("ИНН", "ИНН");
	СвойстваКонтрагентов.Вставить("КПП", "КПП");
	
	Если НЕ ЗначениеЗаполнено(СвойстваКонтрагентов.Имя)
		ИЛИ НЕ ЗначениеЗаполнено(НайденныйИНН) Тогда
		Возврат;
	КонецЕсли;
	ПараметрыФормы = Новый Структура("ТекстЗаполнения", НайденныйИНН); 
	ОткрытьФорму("Справочник." + СвойстваКонтрагентов.Имя + ".ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОбщиеДанныеНажатие(Элемент)
	
	Элемент.ЦветТекста = WebЦвета.Красный;
	
	ЭтаФорма.Элементы.ДекорацияБлагонадежность.ЦветТекста 		   = WebЦвета.Черный;
	ЭтаФорма.Элементы.ДекорацияНалоговыеОтчисления.ЦветТекста 	   = WebЦвета.Черный;
	ЭтаФорма.Элементы.ДекорацияДополнительнаяИнформация.ЦветТекста = WebЦвета.Черный;
	
	Если лкРезультат = Неопределено ИЛИ ТипЗнч(лкРезультат) = Тип("Строка") ИЛИ лкРезультат.Свойство("listName") Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(лкРезультат) И НЕ лкРезультат.result = Ложь Тогда 
		
		ПолучитьМакетНаСервере(лкРезультат, "ОбщиеДанные");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияБлагонадежностьНажатие(Элемент)
	
	Элемент.ЦветТекста = WebЦвета.Красный;
	
	ЭтаФорма.Элементы.ДекорацияОбщиеДанные.ЦветТекста 			   = WebЦвета.Черный;
	ЭтаФорма.Элементы.ДекорацияНалоговыеОтчисления.ЦветТекста 	   = WebЦвета.Черный;
	ЭтаФорма.Элементы.ДекорацияДополнительнаяИнформация.ЦветТекста = WebЦвета.Черный;
	
	Если лкРезультат = Неопределено ИЛИ ТипЗнч(лкРезультат) = Тип("Строка") ИЛИ лкРезультат.Свойство("listName") Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(лкРезультат) И НЕ лкРезультат.result = Ложь Тогда 
		
		ПолучитьМакетНаСервере(лкРезультат, "Благонадежность");
		
		лкОбласть = РезультатОбщиеДанные.Область("R2C3");
		
		Если лкОбласть.Текст = "Да" Тогда 
			
			лкОбласть.ЦветТекста = WebЦвета.Красный; 
			
		ИначеЕсли лкОбласть.Текст = "Нет" Тогда 
			
			лкОбласть.ЦветТекста = WebЦвета.Зеленый;
			
		КонецЕсли;
		
		лкОбласть = РезультатОбщиеДанные.Область("R4C3");
		
		Если лкОбласть.Текст = "Да" Тогда 
			
			лкОбласть.ЦветТекста = WebЦвета.Красный; 
			
		ИначеЕсли лкОбласть.Текст = "Нет" Тогда 
			
			лкОбласть.ЦветТекста = WebЦвета.Зеленый;
			
		КонецЕсли;
		
		лкОбласть = РезультатОбщиеДанные.Область("R6C3");
		
		Если лкОбласть.Текст = "Да" Тогда 
			
			лкОбласть.ЦветТекста = WebЦвета.Красный; 
			
		ИначеЕсли лкОбласть.Текст = "Нет" Тогда 
			
			лкОбласть.ЦветТекста = WebЦвета.Зеленый;
			
		КонецЕсли;
		
		лкОбласть = РезультатОбщиеДанные.Область("R8C3");
		
		Если лкОбласть.Текст = "Да" Тогда 
			
			лкОбласть.ЦветТекста = WebЦвета.Красный; 
			
		ИначеЕсли лкОбласть.Текст = "Нет" Тогда 
			
			лкОбласть.ЦветТекста = WebЦвета.Зеленый;
			
		КонецЕсли;
		
		лкОбласть = РезультатОбщиеДанные.Область("R10C3");
		
		Если лкОбласть.Текст = "Да" Тогда 
			
			лкОбласть.ЦветТекста = WebЦвета.Красный; 
			
		ИначеЕсли лкОбласть.Текст = "Нет" Тогда 
			
			лкОбласть.ЦветТекста = WebЦвета.Зеленый;
			
		КонецЕсли;
		
		лкОбласть = РезультатОбщиеДанные.Область("R12C3");
		
		Если лкОбласть.Текст = "Да" Тогда 
			
			лкОбласть.ЦветТекста = WebЦвета.Красный; 
			
		ИначеЕсли лкОбласть.Текст = "Нет" Тогда 
			
			лкОбласть.ЦветТекста = WebЦвета.Зеленый;
			
		КонецЕсли;
		
		лкОбласть = РезультатОбщиеДанные.Область("R14C3");
		
		Если лкОбласть.Текст = "Да" Тогда 
			
			лкОбласть.ЦветТекста = WebЦвета.Красный; 
			
		ИначеЕсли лкОбласть.Текст = "Нет" Тогда 
			
			лкОбласть.ЦветТекста = WebЦвета.Зеленый;
			
		КонецЕсли;
		
		лкОбласть = РезультатОбщиеДанные.Область("R16C3");
		
		Если лкОбласть.Текст = "Нет" Тогда 
			
			лкОбласть.ЦветТекста = WebЦвета.Зеленый; 
			
		Иначе
			
			лкОбласть.ЦветТекста = WebЦвета.Красный;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияНалоговыеОтчисленияНажатие(Элемент)
	
	Элемент.ЦветТекста = WebЦвета.Красный;

	ЭтаФорма.Элементы.ДекорацияОбщиеДанные.ЦветТекста 			   = WebЦвета.Черный;
	ЭтаФорма.Элементы.ДекорацияБлагонадежность.ЦветТекста 		   = WebЦвета.Черный;
	ЭтаФорма.Элементы.ДекорацияДополнительнаяИнформация.ЦветТекста = WebЦвета.Черный;
	
	Если лкРезультат = Неопределено ИЛИ ТипЗнч(лкРезультат) = Тип("Строка") ИЛИ лкРезультат.Свойство("listName") Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(лкРезультат) И НЕ лкРезультат.result = Ложь Тогда 
		
		ПолучитьМакетНаСервере(лкРезультат, "НалоговыеОтчисления");
			
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДекорацияДополнительнаяИнформацияНажатие(Элемент)
	
	Элемент.ЦветТекста = WebЦвета.Красный;
	
	ЭтаФорма.Элементы.ДекорацияОбщиеДанные.ЦветТекста 		  = WebЦвета.Черный;
	ЭтаФорма.Элементы.ДекорацияБлагонадежность.ЦветТекста 	  = WebЦвета.Черный;
	ЭтаФорма.Элементы.ДекорацияНалоговыеОтчисления.ЦветТекста = WebЦвета.Черный;
	
	Если лкРезультат = Неопределено ИЛИ ТипЗнч(лкРезультат) = Тип("Строка") ИЛИ лкРезультат.Свойство("listName") Тогда
		Возврат;
	КонецЕсли;

	Если ЗначениеЗаполнено(лкРезультат) И НЕ лкРезультат.result = Ложь Тогда 
		
		ПолучитьМакетНаСервере(лкРезультат, "Дополнительно");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьМакетНаСервере(лкОтвет, лкМакет);
	
	РезультатОбщиеДанные.Очистить();
	
	Если Не ЗначениеЗаполнено(лкОтвет) Тогда 
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		НСтр("ru='Ошибка при обращении к сервису. '"));
		Возврат;
		
	ИначеЕсли Не лкОтвет.result Тогда 
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		НСтр("ru='Ошибка при обращении к сервису. '") + лкОтвет.errorMsg);
		Возврат;
		
	ИначеЕсли Не ЗначениеЗаполнено(лкОтвет.trustParameters) Тогда 
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		НСтр("ru='Дополнительные данные не доступны. Ошибка при получении.'") + лкОтвет.taxDeductionsInfo.errorMsg);
		
	КонецЕсли;	

	ОтчетОбъект = РеквизитФормыВЗначение("Объект");
	
	Если лкМакет = "ОбщиеДанные" Тогда 	
		
		ОбластьДанных = ТаблицаОбщихДанных(ОтчетОбъект, лкОтвет); 
		
	ИначеЕсли лкМакет = "Благонадежность" Тогда
		
		ОбластьДанных = ТаблицаБлагонадежность(ОтчетОбъект, лкОтвет); 
		
	ИначеЕсли лкМакет = "НалоговыеОтчисления" Тогда
		
		ОбластьДанных = ТаблицаНалоговыеОтчисления(ОтчетОбъект, лкОтвет); 
		
	ИначеЕсли лкМакет = "Дополнительно" Тогда
		
		ОбластьДанных = ТаблицаДополнительно(ОтчетОбъект, лкОтвет);
		
	КонецЕсли;
	
	РезультатОбщиеДанные.Вывести(ОбластьДанных);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьОтчет(Команда)
	ТекстПредупреждения = НСтр("ru = 'Для данной операции необходимо установить расширение для веб-клиента 1С:Предприятие.'");
	Оповещение = Новый ОписаниеОповещения("ПодключениеРасширенияРаботыСФайламиЗавершение", ЭтаФорма);
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Оповещение,ТекстПредупреждения,Ложь); 
КонецПроцедуры

&НаКлиенте
Процедура ПодключениеРасширенияРаботыСФайламиЗавершение(Подключено, ДополнительныеПараметры) Экспорт
	ПродолжитьСохранитьОтчет();
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьСохранитьОтчет()
	
	Если ТипДанных = ТипДанныхНаименование() Тогда
		ИмяОтчета = БинПоНаименованию();
	Иначе
		ИмяОтчета = СтрокаПоиска;
	КонецЕсли;
	
	ИмяФайлаСохранения 		= "Справка по " + ИмяОтчета + " от " + Формат(ТекущаяДата(), "ДФ=dd.MM.yyyy");
	ТаблицаДляСохранения 	= ОбщаяТаблицаНаСеревере(лкРезультат);
	
	#Если ВебКлиент Тогда
		ДвоичныеДанные 	= ПолучитьИзВременногоХранилища(ТаблицаДляСохранения);
		ОписаниеФайла 	= Новый ОписаниеПередаваемогоФайла(ТаблицаДляСохранения,ИмяФайлаСохранения+".pdf");
		МассивОбъектов 	= Новый Массив();
		
		МассивОбъектов.Добавить(ОписаниеФайла);
		ПолучитьФайл(ТаблицаДляСохранения, ИмяФайлаСохранения+".pdf", Истина);
	#Иначе
		Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
		Диалог.Заголовок      = "Действия формы сохранить как PDF";
		Диалог.Фильтр         = "Документ PDF (*.pdf)|*.pdf";
		Диалог.Расширение     = "pdf";
		Диалог.ПолноеИмяФайла = ИмяФайлаСохранения;
		
		Если Диалог.Выбрать() Тогда
			Если ИспользуетсяРазделениеДанных() Тогда
				ПутьКФайлуЭксель = Ложь;
			Иначе
				ПутьКФайлуЭксель = ФайлСУстановленнойГиперссылкой(Диалог.ПолноеИмяФайла
																,"https://1c.kz/news/detail/89808/#loyal"
																,ТаблицаДляСохранения);
			КонецЕсли;
			Если Не ПутьКФайлуЭксель И Не ПустаяСтрока(Диалог.ПолноеИмяФайла) Тогда
				ТаблицаДляСохранения.АвтоМасштаб = Истина;
				ТаблицаДляСохранения.Записать(Диалог.ПолноеИмяФайла, ТипФайлаТабличногоДокумента.PDF);
			КонецЕсли;
		КонецЕсли;
	#КонецЕсли
КонецПроцедуры

&НаСервереБезКонтекста
Функция ТаблицаОбщихДанных(Знач ОтчетОбъект, Знач лкОтвет)
	Макет = ОтчетОбъект.ПолучитьМакет("ОбщиеДанные");
	
	ОбластьОбщиеДанные = Макет.ПолучитьОбласть("ОбщиеДанные");
	
	ОбластьОбщиеДанные.Параметры.ДатаАктуальности     			= ТекущаяДата();
	ОбластьОбщиеДанные.Параметры.БИН                  			= лкОтвет.commonOrgData.bin;
	ОбластьОбщиеДанные.Параметры.ИсточникБИН            		= лкОтвет.commonOrgData.sourceInfo;
	ОбластьОбщиеДанные.Параметры.Сайт1            				= лкОтвет.commonOrgData.sourceInfo;
	ОбластьОбщиеДанные.Параметры.ПолноеНаименование   			= лкОтвет.commonOrgData.fullName;
	ОбластьОбщиеДанные.Параметры.ИсточникПолноеНаименование 	= лкОтвет.commonOrgData.fullNameSourceInfo;
	ОбластьОбщиеДанные.Параметры.Сайт2            				= лкОтвет.commonOrgData.fullNameSourceInfo;
	ОбластьОбщиеДанные.Параметры.КраткоеНаименование 			= лкОтвет.commonOrgData.name;
	ОбластьОбщиеДанные.Параметры.ИсточникКраткоеНаименование 	= лкОтвет.commonOrgData.sourceInfo;
	ОбластьОбщиеДанные.Параметры.КраткоеНаименованиеКЗ 			= лкОтвет.commonOrgData.namekz;
	ОбластьОбщиеДанные.Параметры.ИсточникКраткоеНаименованиеКЗ 	= лкОтвет.commonOrgData.sourceInfo;
	ОбластьОбщиеДанные.Параметры.Телефон 						= лкОтвет.goszakup.phone;
	ОбластьОбщиеДанные.Параметры.ИсточникТелефон 				= ПреобразованныйАдрес(лкОтвет.goszakup.sourceInfo);
	ОбластьОбщиеДанные.Параметры.Сайт3 							= ПреобразованныйАдрес(лкОтвет.goszakup.sourceInfo);
	ОбластьОбщиеДанные.Параметры.ЭлАдрес 						= лкОтвет.goszakup.email;
	ОбластьОбщиеДанные.Параметры.ИсточникЭлАдрес 				= ПреобразованныйАдрес(лкОтвет.goszakup.sourceInfo);
	ОбластьОбщиеДанные.Параметры.Сайт 							= лкОтвет.goszakup.website;
	ОбластьОбщиеДанные.Параметры.ИсточникСайт 					= ПреобразованныйАдрес(лкОтвет.goszakup.sourceInfo);
	Если лкОтвет.commonOrgData.ip Тогда
	 	ОбластьОбщиеДанные.Параметры.ВидСубъекта = "Индивидуальный предприниматель";
	Иначе	
	 	ОбластьОбщиеДанные.Параметры.ВидСубъекта = "Юридическое лицо";
	КонецЕсли;
	ОбластьОбщиеДанные.Параметры.ИсточникФормаСобственности 	= лкОтвет.commonOrgData.sourceInfo;
	ОбластьОбщиеДанные.Параметры.ВидДеятельности      			= лкОтвет.commonOrgData.okedName;
	ОбластьОбщиеДанные.Параметры.ИсточникВидДеятельности      	= лкОтвет.commonOrgData.sourceInfo;
	ОбластьОбщиеДанные.Параметры.ОКЭД                 			= лкОтвет.commonOrgData.okedCode;
	ОбластьОбщиеДанные.Параметры.ИсточникОКЭД                 	= лкОтвет.commonOrgData.sourceInfo;
	ОбластьОбщиеДанные.Параметры.ЮридическийАдрес     			= лкОтвет.commonOrgData.katoAddress;
	ОбластьОбщиеДанные.Параметры.ИсточникЮридическийАдрес     	= лкОтвет.commonOrgData.sourceInfo;
	ОбластьОбщиеДанные.Параметры.КАТО                 			= лкОтвет.commonOrgData.katoCode;
	ОбластьОбщиеДанные.Параметры.ИсточникКАТО                 	= лкОтвет.commonOrgData.sourceInfo;
	ОбластьОбщиеДанные.Параметры.РазмерПредприятия    			= лкОтвет.commonOrgData.krpName;
	ОбластьОбщиеДанные.Параметры.ИсточникРазмерПредприятия    	= лкОтвет.commonOrgData.sourceInfo;
	ОбластьОбщиеДанные.Параметры.СекторЭкономики     			= лкОтвет.commonOrgData.kse;
	ОбластьОбщиеДанные.Параметры.ИсточникСекторЭкономики    	= лкОтвет.commonOrgData.sourceInfo;
	ОбластьОбщиеДанные.Параметры.ФормаСобственности    			= лкОтвет.commonOrgData.kfs;
	ОбластьОбщиеДанные.Параметры.ИсточникФормаСобственности    	= лкОтвет.commonOrgData.sourceInfo;
	ОбластьОбщиеДанные.Параметры.ДатаРегистрации      			= ?(лкОтвет.commonOrgData.registerDate <> Неопределено,Формат(ПрочитатьДатуJSON(лкОтвет.commonOrgData.registerDate, ФорматДатыJSON.ISO),"ДФ=dd.MM.yyyy"),Неопределено);
	ОбластьОбщиеДанные.Параметры.ИсточникДатаРегистрации      	= лкОтвет.commonOrgData.sourceInfo;
	ОбластьОбщиеДанные.Параметры.ВозрастОрганизации   			= ?(лкОтвет.commonOrgData.orgAge <> Неопределено,НСтр("ru='Лет: '") + лкОтвет.commonOrgData.orgAge.years + НСтр("ru=', Месяцев: '") + лкОтвет.commonOrgData.orgAge.months,Неопределено);
	ОбластьОбщиеДанные.Параметры.ИсточникВозрастОрганизации   	= лкОтвет.commonOrgData.sourceInfo;	
	ОбластьОбщиеДанные.Параметры.ФИОРуководителя      			= лкОтвет.commonOrgData.fio;
	ОбластьОбщиеДанные.Параметры.ИсточникФИОРуководителя      	= лкОтвет.commonOrgData.sourceInfo;
	ОбластьОбщиеДанные.Параметры.УчастникГосЗакупа    			= ?(лкОтвет.goszakup <> Неопределено, лкОтвет.goszakup.result, Неопределено);
	ОбластьОбщиеДанные.Параметры.ИсточникУчастникГосЗакупа    	= ПреобразованныйАдрес(лкОтвет.goszakup.sourceInfo);
	Если лкОтвет.ndsPayer <> Неопределено Тогда
		ОбластьОбщиеДанные.Параметры.ПлательщикНДС    			= лкОтвет.ndsPayer.vatPayer;
		ОбластьОбщиеДанные.Параметры.ИсточникПлательщикНДС    	= лкОтвет.ndsPayerSourceInfo;
		ОбластьОбщиеДанные.Параметры.ДатаПлатежаНДС    			= ПрочитатьДатуJSON(лкОтвет.ndsPayer.fromDate,ФорматДатыJSON.ISO);
		ОбластьОбщиеДанные.Параметры.ИсточникДатаПлатежаНДС    	= лкОтвет.ndsPayerSourceInfo;
	КонецЕсли;
	
	Если лкОтвет.commonOrgData.orgAge = Неопределено ИЛИ лкОтвет.commonOrgData.orgAge.Свойство("years") И лкОтвет.commonOrgData.orgAge.years > 2 Тогда
		ОбластьОбщиеДанные.Рисунки.КартинкаNew.Картинка = Новый Картинка();
	КонецЕсли;
	
	Возврат ОбластьОбщиеДанные;
	
КонецФункции

&НаСервереБезКонтекста
Функция ТаблицаБлагонадежность(Знач ОтчетОбъект, Знач лкОтвет)
	
	Макет = ОтчетОбъект.ПолучитьМакет("Благонадежность");
	
	ОбластьБлагонадежность = Макет.ПолучитьОбласть("Благонадежность");
	
	Если ЗначениеЗаполнено(лкОтвет.trustParameters)Тогда 
		
		Если лкОтвет.trustParameters.taxDebt.result Тогда 
			
			лкtaxDebt = "" + лкОтвет.trustParameters.taxDebt.total + НСтр("ru=' тенге на '") + Формат(ТекущаяДата(),"ДФ=dd.MM.yyyy");
			
		Иначе
			Если ЗначениеЗаполнено(лкОтвет.trustParameters.taxDebt.errorMsg) Тогда
				лкtaxDebt = НСтр("ru='Значение параметра временно недоступно'");
			Иначе 
				лкtaxDebt = НСтр("ru='Нет'");
			КонецЕсли;
		КонецЕсли;	
		
		ОбластьБлагонадежность.Параметры.badSupplier  					= лкОтвет.trustParameters.badSupplier;
		ОбластьБлагонадежность.Параметры.pseudoOrg    					= лкОтвет.trustParameters.pseudoOrg;
		ОбластьБлагонадежность.Параметры.wrongAddress 					= лкОтвет.trustParameters.wrongAddress;
		ОбластьБлагонадежность.Параметры.bankrupt     					= лкОтвет.trustParameters.bankrupt;
		ОбластьБлагонадежность.Параметры.inactive     					= лкОтвет.trustParameters.inactive;
		ОбластьБлагонадежность.Параметры.invalidReg   					= лкОтвет.trustParameters.invalidReg;
		ОбластьБлагонадежность.Параметры.violationTax 					= лкОтвет.trustParameters.violationTax;
		ОбластьБлагонадежность.Параметры.taxDebt      					= лкtaxDebt;
		ОбластьБлагонадежность.Параметры.ИсточникБлагонадежности 		= лкОтвет.trustParameters.taxDebtSourceInfo;
		ОбластьБлагонадежность.Параметры.СайтИсточникБлагонадежности 	= лкОтвет.trustParameters.taxDebtSourceInfo;
		
	КонецЕсли;
	
	Возврат ОбластьБлагонадежность;
	
КонецФункции

&НаСервереБезКонтекста
Функция ТаблицаДополнительно(Знач ОтчетОбъект, Знач лкОтвет)
	
	Макет = ОтчетОбъект.ПолучитьМакет("Дополнительно");
	
	ОбластьДополнительно = Макет.ПолучитьОбласть("Дополнительно");
	
	Если ТипЗнч(лкОтвет.additionalInfo) = Тип("Структура") Тогда
		Если лкОтвет.additionalInfo.Свойство("auditOrg") Тогда
			ОбластьДополнительно.Параметры.auditOrg = лкОтвет.additionalInfo.auditOrg;
		Иначе 
			ОбластьДополнительно.Параметры.auditOrg = "Данные временно недоступны";
		КонецЕсли; 
		
		Если лкОтвет.additionalInfo.Свойство("profAccCertifiedOrg") Тогда
			ОбластьДополнительно.Параметры.profAccCertifiedOrg = лкОтвет.additionalInfo.profAccCertifiedOrg;
		Иначе 
			ОбластьДополнительно.Параметры.profAccCertifiedOrg = "Данные временно недоступны";
		КонецЕсли;
		ОбластьДополнительно.Параметры.ИсточникДополнительно = лкОтвет.additionalInfo.sourceInfo;
		ОбластьДополнительно.Параметры.СайтИсточникДополнительно = лкОтвет.additionalInfo.sourceInfo;
	Иначе 
		ОбластьДополнительно.Параметры.auditOrg  		   = "Данные временно недоступны";
		ОбластьДополнительно.Параметры.profAccCertifiedOrg = "Данные временно недоступны";
	КонецЕсли;
	
	Возврат ОбластьДополнительно;
КонецФункции
	
&НаСервереБезКонтекста
Функция ТаблицаНалоговыеОтчисления(Знач ОтчетОбъект, Знач лкОтвет)
	
	Макет = ОтчетОбъект.ПолучитьМакет("НалоговыеОтчисления");
	
	ОбластьНалоговыеОтчисления = Макет.ПолучитьОбласть("НалоговыеОтчисления");
	
	Если лкОтвет.taxDeductionsInfo = Неопределено ИЛИ Не лкОтвет.taxDeductionsInfo.result Тогда
		Возврат Макет.ПолучитьОбласть("ОшибкаПолученияДанных");
	КонецЕсли; 
	
	тзНалоги = ИнтеграцияWebKassaВызовСервера.МассивВТаблицуЗначений(лкОтвет.taxDeductionsInfo.taxDeductions);
	
	тзНалоги.Колонки.amount.Имя = НСтр("ru='Сумма'");
	тзНалоги.Колонки.year.Имя   = НСтр("ru='Год'");
	
	Диаграмма = ОбластьНалоговыеОтчисления.Рисунки.D1.Объект;
	
	Диаграмма.КоличествоСерий		  = 0; 
	Диаграмма.КоличествоТочек		  = 0; 
	Диаграмма.МаксимумСерий			  = МаксимумСерий.Ограничено; 
	Диаграмма.МаксимумСерийКоличество = 5; 
	
	Серия = Диаграмма.УстановитьСерию(НСтр("ru='Сумма'"));
	Серия.Цвет  = WebЦвета.КоролевскиГолубой;
	
	Для Каждого стр Из тзНалоги Цикл
		
		Точка = Диаграмма.УстановитьТочку(стр.Сумма);
		Точка.Текст = стр.Год;
		
		Диаграмма.УстановитьЗначение(Точка, Серия, стр.Сумма);
		
	КонецЦикла;
	
	Диаграмма.Обновление 		   = Истина;
	Диаграмма.АвтоТранспонирование = Истина;
	Диаграмма.ВидПодписей 		   = ВидПодписейКДиаграмме.Нет; 
	
	Для Каждого стр Из тзНалоги Цикл
		
		Область = Макет.ПолучитьОбласть("Расшифровка");
		
		Область.Параметры.Год   = "" + стр.Год + НСтр("ru=' год:'");
		Область.Параметры.Сумма = Формат(стр.Сумма,"ЧДЦ=0; ЧРГ=' '") + НСтр("ru=' тг'");
		
		ОбластьНалоговыеОтчисления.Вывести(Область);
		
	КонецЦикла;
	
	ОбластьИсточник = Макет.ПолучитьОбласть("Источник");
	ОбластьИсточник.Параметры.ИсточникНалог = лкОтвет.taxDeductionsInfo.sourceInfo;
	ОбластьИсточник.Параметры.СайтИсточникНалог = лкОтвет.taxDeductionsInfo.sourceInfo;
	
	ОбластьНалоговыеОтчисления.Вывести(ОбластьИсточник);
	
	Возврат ОбластьНалоговыеОтчисления;
КонецФункции	
	
&НаСервере
Функция ОбщаяТаблицаНаСеревере(лкОтвет)
	
	ОтчетОбъект 								= РеквизитФормыВЗначение("Объект");
	ОбщаяТаблица 								= Новый ТабличныйДокумент;
	ОбщаяТаблица.ТолькоПросмотр 				= Истина;  
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() Тогда
		ОбщаяТаблица.АвтоМасштаб = Истина;
	КонецЕсли;
	
	МакетОтчета 								= Отчеты.ДосьеКонтрагента.ПолучитьМакет("МакетPDF");
	ОбластьВК 									= МакетОтчета.ПолучитьОбласть("ВК");
	ОбластьВК.Параметры.НаименованиеКомпании 	= лкОтвет.commonOrgData.name;
	ОбластьВК.Параметры.ИННБИН 					= лкОтвет.commonOrgData.bin;
	ОбластьВК.Параметры.ДатаОтчета 				= ТекущаяДатаСеанса();
	
	ОбластьЗаголовок 							= МакетОтчета.ПолучитьОбласть("Заголовок");
	ОбластьНК 									= МакетОтчета.ПолучитьОбласть("НК");
	ОбластьОбщихДанных 							= МакетОтчета.ПолучитьОбласть("ОбластьДанных");
	ДополнительнаяОбласть 						= МакетОтчета.ПолучитьОбласть("ОбластьДоп");
	ОбластьПодпись 								= МакетОтчета.ПолучитьОбласть("Подпись");
	
	ТаблицаОбщихДанных 							= ТаблицаОбщихДанных(ОтчетОбъект, лкОтвет);
	ТаблицаБлагонадежность 						= ТаблицаБлагонадежность(ОтчетОбъект, лкОтвет);
	ТаблицаНалоговыеОтчисления 					= ТаблицаНалоговыеОтчисления(ОтчетОбъект, лкОтвет);
	ТаблицаДополнительно 						= ТаблицаДополнительно(ОтчетОбъект, лкОтвет);
	
	СтруктураОбщейОбласти = Новый Структура("НаименованиеОбласти,Область");
	СтруктураОбщейОбласти.Вставить("НаименованиеОбласти", "Общие данные");
	СтруктураОбщейОбласти.Вставить("Область", ТаблицаОбщихДанных);
	
	СтруктураОбластиБлагонадежность = Новый Структура("НаименованиеОбласти,Область");
	СтруктураОбластиБлагонадежность.Вставить("НаименованиеОбласти", "Благонадежность");
	СтруктураОбластиБлагонадежность.Вставить("Область", ТаблицаБлагонадежность);
	
	СтруктураОбластиНалоговыхОтчислений = Новый Структура("НаименованиеОбласти,Область");
	СтруктураОбластиНалоговыхОтчислений.Вставить("НаименованиеОбласти", "Налоговые отчисления");
	СтруктураОбластиНалоговыхОтчислений.Вставить("Область", ТаблицаНалоговыеОтчисления);
	
	СтруктураОбластиДополнительно = Новый Структура("НаименованиеОбласти,Область");
	СтруктураОбластиДополнительно.Вставить("НаименованиеОбласти", "Дополнительная информация");
	СтруктураОбластиДополнительно.Вставить("Область", ТаблицаДополнительно);
	
	МассивОбластей = Новый Массив;
	МассивОбластей.Добавить(СтруктураОбщейОбласти);
	МассивОбластей.Добавить(СтруктураОбластиБлагонадежность);
	МассивОбластей.Добавить(СтруктураОбластиНалоговыхОтчислений);
	МассивОбластей.Добавить(СтруктураОбластиДополнительно);
	
	НомерОбласти = 1;
	
	Для каждого ЭлементМассива Из МассивОбластей Цикл
		ОбластьОбщихДанных = ЭлементМассива.Область;
		ОбщаяТаблица.Вывести(ОбластьВК);
		ОбластьЗаголовок.Параметры.НаименованиеТаблицы = ЭлементМассива.НаименованиеОбласти;
		ОбщаяТаблица.Вывести(ОбластьЗаголовок);
		
		Если лкОтвет.commonOrgData.orgAge <> Неопределено И лкОтвет.commonOrgData.orgAge.Свойство("years")И лкОтвет.commonOrgData.orgAge.years < 2 И НомерОбласти = 1 Тогда
			ОбластьОбщихДанных.Рисунки.КартинкаNew.Картинка = БиблиотекаКартинок.КонтрагентNew;
			ОбластьОбщихДанных.Рисунки.КартинкаNew.ВыводитьНаПечать = Истина;
			ОбластьОбщихДанных.Рисунки.КартинкаNew.Расположить(МакетОтчета.Области.ЯчейкаРисунка);
		КонецЕсли;
		
		Если НомерОбласти = 2 Тогда
			Для Номерстроки = 1 По ОбластьОбщихДанных.ВысотаТаблицы Цикл
				Ячейка = ОбластьОбщихДанных.Область(Номерстроки,3,Номерстроки,3);
				ИмяПараметра = Ячейка.Параметр;
				Если ИмяПараметра <> Неопределено Тогда
					ЗначениеПараметра = лкОтвет.trustParameters[ИмяПараметра];
					
					Если ИмяПараметра = "taxDebt" Тогда 
						Если ЗначениеПараметра.result Тогда 
							ЗначениеПараметра = "" + ЗначениеПараметра.total + НСтр("ru=' тенге на '") + Формат(ТекущаяДата(),"ДФ=dd.MM.yyyy");
						Иначе
							Если ЗначениеЗаполнено(ЗначениеПараметра.errorMsg) Тогда
								ЗначениеПараметра = НСтр("ru='Значение параметра временно недоступно'");
							Иначе 
								ЗначениеПараметра = Ложь;
							КонецЕсли;
						КонецЕсли;
					КонецЕсли;
					
					Если ЗначениеПараметра = Ложь Тогда
						Ячейка.ЦветТекста = WebЦвета.Зеленый; 
					Иначе	
						Ячейка.ЦветТекста = WebЦвета.Красный; 
					КонецЕсли; 
				КонецЕсли; 
			КонецЦикла; 
		КонецЕсли;
		
		ОбщаяТаблица.Вывести(ОбластьОбщихДанных);
		МассивПроверяемыхОбластей = Новый Массив;
		
		Если НЕ ИспользуетсяРазделениеДанных() Тогда
			// Для локальной версии выводим нижний (рекламный) колонтитул
			МассивПроверяемыхОбластей.Добавить(ДополнительнаяОбласть);
			МассивПроверяемыхОбластей.Добавить(ОбластьНК);
			МассивПроверяемыхОбластей.Добавить(ОбластьПодпись);
			
			Если Не ОбщаяТаблица.ПроверитьВывод(МассивПроверяемыхОбластей) Тогда
				ОбщаяТаблица.ВывестиГоризонтальныйРазделительСтраниц();
			Иначе
				Пока ОбщаяТаблица.ПроверитьВывод(МассивПроверяемыхОбластей) Цикл
					ОбщаяТаблица.Вывести(ДополнительнаяОбласть);
				КонецЦикла;   			              			
				ПараметрПрограммаЛояльности = Новый ФорматированнаяСтрока("программе лояльности",,WebЦвета.Синий,,"https://1c.kz/news/detail/89808/#loyal");
				ОбластьПодпись.Параметры.ДатаОкончания = лкОтвет.itsExpireDate;
				ОбластьПодпись.Параметры.ПрограммаЛояльности = ПараметрПрограммаЛояльности;
				
				ОбщаяТаблица.Вывести(ОбластьНК);
				ОбщаяТаблица.Вывести(ОбластьПодпись);
			КонецЕсли;
		КонецЕсли;
				
		ОбщаяТаблица.ВывестиГоризонтальныйРазделительСтраниц();
		НомерОбласти = НомерОбласти+1;
		
	КонецЦикла; 
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() Тогда
		Возврат ВременныйФайлНаСервере(ОбщаяТаблица);
	Иначе
		Возврат ОбщаяТаблица;	
	КонецЕсли;                                          

КонецФункции 

&НаКлиенте
Функция ФайлСУстановленнойГиперссылкой(ФайлПДФ, СтрокаURL, ТаблицаДляСохранения)
	Попытка
		МассивЯчеек 	= Новый Массив;
		СтруктураЯчеек 	= Новый Структура("Строка, Колонка");
		Каталог 		= КаталогВременныхФайлов();
		ИмяФайла 		= Строка(Новый УникальныйИдентификатор) + ".xlsx";
		ПутьКФайлу 		= Каталог + ИмяФайла;
		
		ТаблицаДляСохранения.Записать(ПутьКФайлу, ТипФайлаТабличногоДокумента.XLSX);
		
		MSExcel 		= Новый COMОбъект("Excel.Application");
		MSExcel.Visible = Ложь;
		
		ExcelДокумент 	= MSExcel.WorkBooks.Open(ПутьКФайлу);
		
		MySheet 		= ExcelДокумент.Worksheets(1);
		ВсегоКолонок 	= MySheet.Cells(1,1).SpecialCells(11).Column;
		ВсегоСтрок 		= MySheet.Cells(1,1).SpecialCells(11).Row;
		Диапазон		= MySheet.UsedRange;
		
		НайденнаяЯчейка = Диапазон.Find("программе лояльности", Диапазон.Cells(1, 1), -4123, 1, 1, 1, 0, 0);
		СтрокаЯчейки 	= НайденнаяЯчейка.Cells.Row;
		КолонкаЯчейки 	= Сред(НайденнаяЯчейка.Cells.Address,2,1);
		СтруктураЯчеек.Вставить("Строка",СтрокаЯчейки);
		СтруктураЯчеек.Вставить("Колонка",КолонкаЯчейки);
		МассивЯчеек.Добавить(СтруктураЯчеек);
		АдресПервойЯчейки 	= НайденнаяЯчейка.Address;
		НайденнаяЯчейка 	= Диапазон.FindNext(НайденнаяЯчейка);
		Пока НайденнаяЯчейка.Address<>АдресПервойЯчейки Цикл
			
			СтрокаЯчейки 	= НайденнаяЯчейка.Cells.Row;
			КолонкаЯчейки 	= Сред(НайденнаяЯчейка.Cells.Address,2,1);
			СтруктураЯчеек 	= Новый Структура();
			
			СтруктураЯчеек.Вставить("Строка",СтрокаЯчейки);
			СтруктураЯчеек.Вставить("Колонка",КолонкаЯчейки);
			
			МассивЯчеек.Добавить(СтруктураЯчеек);
			НайденнаяЯчейка = Диапазон.FindNext(НайденнаяЯчейка);
		КонецЦикла; 
		
		Для каждого ЗначениеМассива Из МассивЯчеек Цикл
			Ячейка = MySheet.Cells(ЗначениеМассива.Строка, ЗначениеМассива.Колонка);
			MySheet.Hyperlinks.Add(Ячейка,СтрокаURL,,);
			Ячейка.Font.Size = 9;
			Ячейка.Font.Name = "Arial";
			Ячейка.Font.Bold = 1;
		КонецЦикла; 
		
		MySheet.PageSetup.Zoom 				= False;
		MySheet.PageSetup.FitToPagesWide 	= 1;   
		MySheet.PageSetup.FitToPagesTall 	= False;		
		ExcelДокумент.Save();
		ExcelДокумент.ExportAsFixedFormat(0, ФайлПДФ , 0);
		
		ExcelДокумент.Close();
		MSExcel.Quit();	
		УдалитьФайлы(ПутьКФайлу);
		
		Возврат Истина;
		
	Исключение
		
		Возврат Ложь;
		
	КонецПопытки; 
	
КонецФункции 

&НаСервереБезКонтекста
Функция ИспользуетсяРазделениеДанных()
	Возврат ОбщегоНазначения.РазделениеВключено();
КонецФункции 

&НаСервереБезКонтекста
Функция ВременныйФайлНаСервере(Знач ТаблицаДляСохранения)
	
	ВременныйФайл 		= ПолучитьИмяВременногоФайла();
	ТаблицаДляСохранения.Записать(ВременныйФайл,ТипФайлаТабличногоДокумента.PDF);
	АдресФайлаНаСервере = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ВременныйФайл));
	
	Возврат АдресФайлаНаСервере;
	
КонецФункции 

&НаКлиенте
Процедура ТипДанныхПриИзменении(Элемент)
	
	Элементы.СтрокаПоиска.ВыделенныйТекст = "";
	СтрокаПоиска = "";
	
	Если ТипДанных = ТипДанныхБИН() Тогда
		Элементы.СтрокаПоиска.ПодсказкаВвода = "БИН / ИИН контрагента";
		Элементы.СтрокаПоиска.Подсказка = "БИН / ИИН контрагента, по которому нужно сформировать досье";
		Элементы.СтрокаПоиска.СписокВыбора.Очистить();
		Элементы.СтрокаПоиска.КнопкаВыпадающегоСписка = Ложь;
	Иначе
		Элементы.СтрокаПоиска.ПодсказкаВвода = "Наименование контрагента";
		Элементы.СтрокаПоиска.Подсказка = "Наименование контрагента, по которому нужно сформировать досье";
		СформироватьСписокДляВыбора();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТаблицуСоответствий(ДанныеКонтрагентов)

	Для Каждого СтрокаДанных Из ДанныеКонтрагентов Цикл
		НоваяСтрока = ДанныеЗапросаПоНаименованию.Добавить();
		НоваяСтрока.Наименование = СтрокаДанных.nameRu;
		НоваяСтрока.БИН = СтрокаДанных.bin;
	КонецЦикла;

КонецПроцедуры // ЗаполнитьТаблицуСоответствий()

&НаКлиенте
Процедура СформироватьСписокДляВыбора()

	Для Каждого ЭлементТаблицы Из ДанныеЗапросаПоНаименованию Цикл
		Элементы.СтрокаПоиска.СписокВыбора.Добавить(ЭлементТаблицы.Наименование, 
													ЭлементТаблицы.Наименование + " (" +ЭлементТаблицы.БИН +")");
	КонецЦикла;
	
	Если ЗначениеЗаполнено(Элементы.СтрокаПоиска.СписокВыбора) Тогда
		Элементы.СтрокаПоиска.КнопкаВыпадающегоСписка = Истина;
		ПоказатьВыборИзСписка(Новый ОписаниеОповещения("СформироватьСписокДляВыбораЗавершение", ЭтаФорма), Элементы.СтрокаПоиска.СписокВыбора, Элементы.СтрокаПоиска);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СформироватьСписокДляВыбораЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент <> Неопределено Тогда
		СтрокаПоиска = ВыбранныйЭлемент.Значение;
	КонецЕсли;	

КонецПроцедуры // СформироватьСписокДляВыбора()

&НаКлиенте
Процедура СтрокаПоискаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ТипДанных = ТипДанныхНаименование() И ЗначениеЗаполнено(Текст) Тогда
		
		Если ЗначениеЗаполнено(Элемент.СписокВыбора) И Элемент.СписокВыбора.НайтиПоЗначению(Текст) = Неопределено Тогда
			
			ПоказатьВопрос(Новый ОписаниеОповещения("СтрокаПоискаОкончаниеВводаТекстаЗавершение", ЭтаФорма), 
						НСтр("ru='Не выбран элемент из списка! 
						|Вы хотите изменить параметры поиска?'"),
						РежимДиалогаВопрос.ДаНет);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаОкончаниеВводаТекстаЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ДанныеЗапросаПоНаименованию.Очистить();
		Элементы.СтрокаПоиска.СписокВыбора.Очистить();
		Элементы.СтрокаПоиска.КнопкаВыпадающегоСписка = Ложь;
		СтрокаПоиска = Элементы.СтрокаПоиска.ТекстРедактирования;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция БинПоНаименованию()

	Отбор = Новый Структура("Наименование", СтрокаПоиска);
	НайденныеСтроки = ДанныеЗапросаПоНаименованию.НайтиСтроки(Отбор);
	
	Если НайденныеСтроки.Количество() > 0 Тогда
		Возврат НайденныеСтроки[0].БИН;
	Иначе
		Возврат Неопределено;
	КонецЕсли;

КонецФункции // БинПоНаименованию()

&НаКлиенте
Процедура СтрокаПоискаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ТипДанных = ТипДанныхНаименование() И ЗначениеЗаполнено(Элемент.СписокВыбора) Тогда
		
		СтандартнаяОбработка = Не ЗначениеЗаполнено(Текст);
	
		ДанныеВыбора = ДанныеВыбора(Текст, Элемент.СписокВыбора);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ДанныеВыбора(Знач Строка, СписокВыбора)
	
	Результат = Новый СписокЗначений;
	
	Если Не ЗначениеЗаполнено(Строка) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Для Каждого Элемент Из СписокВыбора Цикл
		ПредставлениеЭлемента = Элемент.Представление;
		
		ОстатокСтрокаПоиска = ПредставлениеЭлемента;
		
		ФорматированныеСтроки = Новый Массив;
		Для Каждого Подстрока Из СтрРазделить(Строка, " ", Ложь) Цикл
			Позиция = СтрНайти(НРег(ОстатокСтрокаПоиска), НРег(Подстрока));
			Если Позиция = 0 Тогда
				ФорматированныеСтроки = Неопределено;
				Прервать;
			КонецЕсли;
			
			ПодстрокаДоВхождения = Лев(ОстатокСтрокаПоиска, Позиция - 1);
			ПодстрокаВхождения = Сред(ОстатокСтрокаПоиска, Позиция, СтрДлина(Подстрока));
			ОстатокСтрокаПоиска = Сред(ОстатокСтрокаПоиска, Позиция + СтрДлина(Подстрока));
			
			ФорматированныеСтроки.Добавить(ПодстрокаДоВхождения);
			ФорматированныеСтроки.Добавить(Новый ФорматированнаяСтрока(ПодстрокаВхождения, Новый Шрифт( , , Истина), Новый Цвет(0,128,0)));
		КонецЦикла;
		
		Если Не ЗначениеЗаполнено(ФорматированныеСтроки) Тогда
			Продолжить;
		КонецЕсли;
		
		ФорматированныеСтроки.Добавить(ОстатокСтрокаПоиска);
		СтрокаСПодсветкой = Новый ФорматированнаяСтрока(ФорматированныеСтроки);
		
		Результат.Добавить(Элемент.Значение, СтрокаСПодсветкой);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ТипДанныхБИН()

	Возврат "БИН";	

КонецФункции // ТипДанныхБИН()

&НаКлиентеНаСервереБезКонтекста
Функция ТипДанныхНаименование()

	Возврат "Наименование";	

КонецФункции // ТипДанныхНаименование()

&НаКлиенте
Процедура РезультатОбщиеДанныеВыбор(Элемент, Область, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(Область.Расшифровка) Тогда
		ТекстПредупреждения = НСтр("ru = 'Для данной операции необходимо установить расширение для веб-клиента 1С:Предприятие.'");
		Оповещение = Новый ОписаниеОповещения("ОткрытьПриложениеПродолжить", ЭтаФорма, Новый Структура("СтрокаЗапуска", Область.Расшифровка));
		ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Оповещение,ТекстПредупреждения,Ложь);
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПреобразованныйАдрес(ИсходныйАдрес)

	СимволПоиска = СтрНайти(ИсходныйАдрес,"ows.");
	НачалоСтроки = Лев(ИсходныйАдрес,СимволПоиска-1);
	КонецСтроки = Прав(ИсходныйАдрес,СтрДлина(ИсходныйАдрес)-(СимволПоиска+3));
	
	Возврат НачалоСтроки+КонецСтроки;

КонецФункции // ПреобразованныйАдрес()

&НаКлиенте
Процедура ОткрытьПриложениеПродолжить(РасширениеПодключено, ДополнительныеПараметры) Экспорт
	
	Если РасширениеПодключено Тогда
		Оповещение = Новый ОписаниеОповещения("ОткрытьПриложениеЗавершение",ЭтаФорма);
		НачатьЗапускПриложения(Оповещение, ДополнительныеПараметры.СтрокаЗапуска);
	КонецЕсли;
	
КонецПроцедуры // ОткрытьПриложениеПродолжить()

&НаКлиенте
Процедура ОткрытьПриложениеЗавершение(КодОтвета, ДополнительныеПараметры) Экспорт

КонецПроцедуры 


