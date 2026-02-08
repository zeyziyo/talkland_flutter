import 'dart:convert';
import 'dart:io';

void main() async {
  final dir = Directory('lib/l10n');
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.arb')).toList();
  
  final Map<String, Map<String, String>> l10nData = {
    'af': {'practiceModeTitle': 'Oefen', 'chatAiChat': 'Klets', 'tutorialAiChatTitle': 'Klets', 'helpMode3Desc': 'Oefen deur te luister en sinne na te boots.', 'helpModeChatDesc': 'Praat met persona om regte gesprekke te oefen.'},
    'am': {'practiceModeTitle': 'ልምምድ', 'chatAiChat': 'ውይይት', 'tutorialAiChatTitle': 'ውይይት', 'helpMode3Desc': 'በማዳመጥ እና በመድገም ይለማመዱ።', 'helpModeChatDesc': 'ከባለሙያዎች ጋር በመነጋገር እውነተኛ ውይይትን ይለማመዱ።'},
    'ar': {'practiceModeTitle': 'ممارسة', 'chatAiChat': 'دردشة', 'tutorialAiChatTitle': 'دردشة', 'helpMode3Desc': 'تدرب من خلال الاستماع والترديد.', 'helpModeChatDesc': 'تحدث مع الشخصيات لممارسة المحادثة الحقيقية.'},
    'as': {'practiceModeTitle': 'চৰ্চা', 'chatAiChat': 'চাট', 'tutorialAiChatTitle': 'চাট', 'helpMode3Desc': 'শুনি আৰু অনুকৰণ কৰি চৰ্চা কৰক।', 'helpModeChatDesc': 'প্ৰকৃত কথোপকথন চৰ্চা কৰিবলৈ চাট কৰক।'},
    'az': {'practiceModeTitle': 'Məşq', 'chatAiChat': 'Çat', 'tutorialAiChatTitle': 'Çat', 'helpMode3Desc': 'Dinləyərək və təkrarlayaraq məşq edin.', 'helpModeChatDesc': 'Real söhbət məşqi etmək üçün personajlarla danışın.'},
    'be': {'practiceModeTitle': 'Практыка', 'chatAiChat': 'Чат', 'tutorialAiChatTitle': 'Чат', 'helpMode3Desc': 'Практыкуйцеся, слухаючы і паўтараючы.', 'helpModeChatDesc': 'Размаўляйце з персанажамі для практыкі рэальнай размовы.'},
    'bg': {'practiceModeTitle': 'Практика', 'chatAiChat': 'Чат', 'tutorialAiChatTitle': 'Чат', 'helpMode3Desc': 'Практикувайте чрез слушане и повтаряне.', 'helpModeChatDesc': 'Говорете с персонажи за реална практика.'},
    'bn': {'practiceModeTitle': 'অনুশীলন', 'chatAiChat': 'চ্যাট', 'tutorialAiChatTitle': 'চ্যাট', 'helpMode3Desc': 'শুনে এবং অনুকরণ করে অনুশীলন করুন।', 'helpModeChatDesc': 'আসল কথোপকথন অনুশীলনের জন্য চ্যাট করুন।'},
    'bo': {'practiceModeTitle': 'སྦྱོང་བརྡར།', 'chatAiChat': 'ཁ་བརྡ།', 'tutorialAiChatTitle': 'ཁ་བརྡ།', 'helpMode3Desc': 'ཉན་པ་དང་ལད་མོ་བྱས་ནས་སྦྱོང་བརྡར་བྱེད།', 'helpModeChatDesc': 'དངོས་ཡོད་ཁ་བརྡ་སྦྱོང་བརྡར་བྱེད་པར་ཁ་བརྡ་བྱེད།'},
    'bs': {'practiceModeTitle': 'Vježba', 'chatAiChat': 'Chat', 'tutorialAiChatTitle': 'Chat', 'helpMode3Desc': 'Vježbajte slušajući i ponavljajući.', 'helpModeChatDesc': 'Razgovarajte sa personama za vježbu stvarnog razgovora.'},
    'ca': {'practiceModeTitle': 'Pràctica', 'chatAiChat': 'Xat', 'tutorialAiChatTitle': 'Xat', 'helpMode3Desc': 'Practica escoltant i repetint.', 'helpModeChatDesc': 'Parla amb personatges per practicar la conversa real.'},
    'cs': {'practiceModeTitle': 'Praxe', 'chatAiChat': 'Chat', 'tutorialAiChatTitle': 'Chat', 'helpMode3Desc': 'Procvičujte poslechem a opakováním.', 'helpModeChatDesc': 'Mluvte s personami pro nácvik skutečné konverzace.'},
    'cy': {'practiceModeTitle': 'Ymarfer', 'chatAiChat': 'Sgwrs', 'tutorialAiChatTitle': 'Sgwrs', 'helpMode3Desc': 'Ymarferwch drwy wrando ac ailadrodd.', 'helpModeChatDesc': 'Siaradwch â phersonas i ymarfer sgwrs go iawn.'},
    'da': {'practiceModeTitle': 'Øvelse', 'chatAiChat': 'Chat', 'tutorialAiChatTitle': 'Chat', 'helpMode3Desc': 'Øv dig ved at lytte og gentage.', 'helpModeChatDesc': 'Tal med personaer for at øve rigtig samtale.'},
    'de': {'practiceModeTitle': 'Übung', 'chatAiChat': 'Chat', 'tutorialAiChatTitle': 'Chat', 'helpMode3Desc': 'Üben Sie durch Zuhören und Nachsprechen.', 'helpModeChatDesc': 'Sprechen Sie mit Personas, um echte Gespräche zu üben.'},
    'el': {'practiceModeTitle': 'Εξάσκηση', 'chatAiChat': 'Συνομιλία', 'tutorialAiChatTitle': 'Συνομιλία', 'helpMode3Desc': 'Εξασκηθείτε ακούγοντας και επαναλαμβάνοντας.', 'helpModeChatDesc': 'Μιλήστε με χαρακτήρες για πραγματική εξάσκηση.'},
    'en': {'practiceModeTitle': 'Practice', 'chatAiChat': 'Chat', 'tutorialAiChatTitle': 'Chat', 'helpMode3Desc': 'Practice by listening to and shadowing sentences.', 'helpModeChatDesc': 'Talk to personas to practice real conversation and save useful sentences.'},
    'es': {'practiceModeTitle': 'Práctica', 'chatAiChat': 'Chat', 'tutorialAiChatTitle': 'Chat', 'helpMode3Desc': 'Practica escuchando y repitiendo.', 'helpModeChatDesc': 'Habla con personajes para practicar conversaciones reales.'},
    'et': {'practiceModeTitle': 'Harjutamine', 'chatAiChat': 'Vestlus', 'tutorialAiChatTitle': 'Vestlus', 'helpMode3Desc': 'Harjutage kuulates ja korrates.', 'helpModeChatDesc': 'Rääkige personadega tõelise vestluse harjutamiseks.'},
    'eu': {'practiceModeTitle': 'Praktika', 'chatAiChat': 'Txat', 'tutorialAiChatTitle': 'Txat', 'helpMode3Desc': 'Praktikatu entzunez eta errepikatuz.', 'helpModeChatDesc': 'Pertsonaiekin hitz egin benetako elkarrizketa praktikatzeko.'},
    'fa': {'practiceModeTitle': 'تمرین', 'chatAiChat': 'چت', 'tutorialAiChatTitle': 'چت', 'helpMode3Desc': 'با گوش دادن و تکرار تمرین کنید.', 'helpModeChatDesc': 'برای تمرین مکالمه واقعی با شخصیت‌ها صحبت کنید.'},
    'fi': {'practiceModeTitle': 'Harjoitus', 'chatAiChat': 'Chat', 'tutorialAiChatTitle': 'Chat', 'helpMode3Desc': 'Harjoittele kuuntelemalla ja toistamalla.', 'helpModeChatDesc': 'Puhu personoille harjoitellaksesi oikeaa keskustelua.'},
    'fil': {'practiceModeTitle': 'Pagsasanay', 'chatAiChat': 'Chat', 'tutorialAiChatTitle': 'Chat', 'helpMode3Desc': 'Magsanay sa pamamagitan ng pakikinig at pag-uulit.', 'helpModeChatDesc': 'Makipag-usap sa mga persona para sa tunay na usapan.'},
    'fr': {'practiceModeTitle': 'Pratique', 'chatAiChat': 'Chat', 'tutorialAiChatTitle': 'Chat', 'helpMode3Desc': 'Pratiquez en écoutant et en répétant.', 'helpModeChatDesc': 'Parlez à des personnages pour pratiquer la conversation réelle.'},
    'gl': {'practiceModeTitle': 'Práctica', 'chatAiChat': 'Chat', 'tutorialAiChatTitle': 'Chat', 'helpMode3Desc': 'Practica escoitando e repetindo.', 'helpModeChatDesc': 'Fala con personaxes para practicar conversas reais.'},
    'gu': {'practiceModeTitle': 'અભ્યાસ', 'chatAiChat': 'ચેટ', 'tutorialAiChatTitle': 'ચેટ', 'helpMode3Desc': 'સાંભળીને અને રિપીટ કરીને અભ્યાસ કરો.', 'helpModeChatDesc': 'અસલી વાતચીત માટે પાત્રો સાથે વાત કરો.'},
    'he': {'practiceModeTitle': 'תרגול', 'chatAiChat': 'צ\'אט', 'tutorialAiChatTitle': 'צ\'אט', 'helpMode3Desc': 'תרגלו באמצעות האזנה וחזרה.', 'helpModeChatDesc': 'דברו עם דמויות לתרגול שיחה אמיתית.'},
    'hi': {'practiceModeTitle': 'अभ्यास', 'chatAiChat': 'चैट', 'tutorialAiChatTitle': 'चैट', 'helpMode3Desc': 'सुनकर और दोहराकर अभ्यास करें।', 'helpModeChatDesc': 'असली बातचीत के अभ्यास के लिए पात्रों से बात करें।'},
    'hr': {'practiceModeTitle': 'Vježba', 'chatAiChat': 'Chat', 'tutorialAiChatTitle': 'Chat', 'helpMode3Desc': 'Vježbajte slušajući i ponavljajući.', 'helpModeChatDesc': 'Razgovarajte s personama za vježbu stvarnog razgovora.'},
    'hu': {'practiceModeTitle': 'Gyakorlás', 'chatAiChat': 'Chat', 'tutorialAiChatTitle': 'Chat', 'helpMode3Desc': 'Gyakoroljon hallás és ismétlés után.', 'helpModeChatDesc': 'Beszéljen karakterekkel a valódi társalgás gyakorlásához.'},
    'hy': {'practiceModeTitle': 'Պրակտիկա', 'chatAiChat': 'Չատ', 'tutorialAiChatTitle': 'Չատ', 'helpMode3Desc': 'Պրակտիկա արեք լսելով և կրկնելով:', 'helpModeChatDesc': 'Խոսեք կերպարների հետ իրական զրույցի համար:'},
    'id': {'practiceModeTitle': 'Latihan', 'chatAiChat': 'Obrolan', 'tutorialAiChatTitle': 'Obrolan', 'helpMode3Desc': 'Berlatih dengan mendengarkan dan mengulang.', 'helpModeChatDesc': 'Bicara dengan persona untuk melatih percakapan nyata.'},
    'is': {'practiceModeTitle': 'Æfing', 'chatAiChat': 'Spjall', 'tutorialAiChatTitle': 'Spjall', 'helpMode3Desc': 'Æfðu þig með því að hlusta og endurtaka.', 'helpModeChatDesc': 'Talaðu við persónur til að æfa raunveruleg samtöl.'},
    'it': {'practiceModeTitle': 'Pratica', 'chatAiChat': 'Chat', 'tutorialAiChatTitle': 'Chat', 'helpMode3Desc': 'Pratica ascoltando e ripetendo.', 'helpModeChatDesc': 'Parla con i personaggi per praticare conversazioni reali.'},
    'ja': {'practiceModeTitle': '練習', 'chatAiChat': 'チャット', 'tutorialAiChatTitle': 'チャット', 'helpMode3Desc': '聞いてシャドーイングすることで練習します。', 'helpModeChatDesc': 'ペルソナと対話して実戦会話を練習します。'},
    'ka': {'practiceModeTitle': 'პრაქტიკა', 'chatAiChat': 'ჩატი', 'tutorialAiChatTitle': 'ჩატი', 'helpMode3Desc': 'ივარჯიშეთ მოსმენით და გამეორებით.', 'helpModeChatDesc': 'ესაუბრეთ პერსონაჟებს რეალური საუბრისთვის.'},
    'kk': {'practiceModeTitle': 'Тәжірибе', 'chatAiChat': 'Чат', 'tutorialAiChatTitle': 'Чат', 'helpMode3Desc': 'Тыңдау және қайталау арқылы жаттығыңыз.', 'helpModeChatDesc': 'Нағыз сөйлесуді үйрену үшін кейіпкерлермен сөйлесіңіз.'},
    'km': {'practiceModeTitle': 'ការអនុវត្ត', 'chatAiChat': 'ជជែក', 'tutorialAiChatTitle': 'ជជែក', 'helpMode3Desc': 'អនុវត្តដោយស្តាប់ និងនិយាយតាម។', 'helpModeChatDesc': 'ជជែកជាមួយតួអង្គដើម្បីអនុវត្តការសន្ទនាពិត។'},
    'kn': {'practiceModeTitle': 'ಅಭ್ಯಾಸ', 'chatAiChat': 'ಚಾಟ್', 'tutorialAiChatTitle': 'ಚಾಟ್', 'helpMode3Desc': 'ಕೇಳುವ ಮತ್ತು ಪುನರಾವರ್ತಿಸುವ ಮೂಲಕ ಅಭ್ಯಾಸ ಮಾಡಿ.', 'helpModeChatDesc': 'ನಿಜವಾದ ಸಂಭಾಷಣೆಗಾಗಿ ಪಾತ್ರಗಳೊಂದಿಗೆ ಮಾತನಾಡಿ.'},
    'ko': {'practiceModeTitle': '연습', 'chatAiChat': '채팅', 'tutorialAiChatTitle': '채팅', 'helpMode3Desc': '음성을 듣고 쉐도잉하여 연습합니다.', 'helpModeChatDesc': '페르소나와 대화하며 실전 회화를 연습하세요.'},
    'ky': {'practiceModeTitle': 'Көнүгүү', 'chatAiChat': 'Чат', 'tutorialAiChatTitle': 'Чат', 'helpMode3Desc': 'Угуу жана кайталоо аркылы машыгыңыз.', 'helpModeChatDesc': 'Чыныгы сүйлөшүүнү үйрөнүү үчүн каармандар менен сүйлөшүңүз.'},
    'lo': {'practiceModeTitle': 'ການຝຶກຊ້ອມ', 'chatAiChat': 'ແຊັດ', 'tutorialAiChatTitle': 'ແຊັດ', 'helpMode3Desc': 'ຝຶກຊ້ອມໂດຍການຟັງ ແລະ ເວົ້າຕາມ.', 'helpModeChatDesc': 'ລົມກັບຕົວລະຄອນເພື່ອຝຶກສົນທະນາຕົວຈິງ.'},
    'lt': {'practiceModeTitle': 'Praktika', 'chatAiChat': 'Pokalbiai', 'tutorialAiChatTitle': 'Pokalbiai', 'helpMode3Desc': 'Praktikuokitės klausydami ir kartodami.', 'helpModeChatDesc': 'Kalbėkite su personažais tikram pokalbiui.'},
    'lv': {'practiceModeTitle': 'Prakse', 'chatAiChat': 'Tērzēšana', 'tutorialAiChatTitle': 'Tērzēšana', 'helpMode3Desc': 'Praktizējieties klausoties un atkārtojot.', 'helpModeChatDesc': 'Runājiet ar personāžiem īstai sarunai.'},
    'mk': {'practiceModeTitle': 'Практика', 'chatAiChat': 'Чат', 'tutorialAiChatTitle': 'Чат', 'helpMode3Desc': 'Вежбајте со слушање и повторување.', 'helpModeChatDesc': 'Зборувајте со ликови за вистинска практика.'},
    'ml': {'practiceModeTitle': 'പരിശീലനം', 'chatAiChat': 'ചാറ്റ്', 'tutorialAiChatTitle': 'ചാറ്റ്', 'helpMode3Desc': 'ശ്രദ്ധിച്ചും ആവർത്തിച്ചും പരിശീലിക്കുക.', 'helpModeChatDesc': 'യഥാർത്ഥ സംഭാഷണത്തിനായി കഥാപാത്രങ്ങളോട് സംസാരിക്കുക.'},
    'mn': {'practiceModeTitle': 'Дасгал', 'chatAiChat': 'Чат', 'tutorialAiChatTitle': 'Чат', 'helpMode3Desc': 'Сонсож давтах замаар дасгал хийх.', 'helpModeChatDesc': 'Бодит ярианы дасгал хийхээр дүрүүдтэй ярилц.'},
    'mr': {'practiceModeTitle': 'सराव', 'chatAiChat': 'चॅट', 'tutorialAiChatTitle': 'चॅट', 'helpMode3Desc': 'एकून आणि पुन्हा बोलून सराव करा.', 'helpModeChatDesc': 'खऱ्या संभाषणासाठी पात्रांशी बोला.'},
    'ms': {'practiceModeTitle': 'Latihan', 'chatAiChat': 'Sembang', 'tutorialAiChatTitle': 'Sembang', 'helpMode3Desc': 'Berlatih dengan mendengar dan mengulang.', 'helpModeChatDesc': 'Bercakap dengan persona untuk melatih perbualan.'},
    'my': {'practiceModeTitle': 'လေ့ကျင့်ခန်း', 'chatAiChat': 'ချက်', 'tutorialAiChatTitle': 'ချက်', 'helpMode3Desc': 'နားထောင်ပြီး လိုက်ပြောခြင်းဖြင့် လေ့ကျင့်ပါ။', 'helpModeChatDesc': 'တကယ်ပြောဆိုရန် ဇာတ်ကောင်များနှင့် စကားပြောပါ။'},
    'nb': {'practiceModeTitle': 'Øvelse', 'chatAiChat': 'Chat', 'tutorialAiChatTitle': 'Chat', 'helpMode3Desc': 'Øv ved å lytte og gjenta.', 'helpModeChatDesc': 'Snakk med personaer for å øve på samtale.'},
    'ne': {'practiceModeTitle': 'अभ्यास', 'chatAiChat': 'च्याट', 'tutorialAiChatTitle': 'च्याट', 'helpMode3Desc': 'सुनेर र दोहोर्याएर अभ्यास गर्नुहोस्।', 'helpModeChatDesc': 'असली कुराकानीका लागि पात्रहरूसँग बोल्नुहोस्।'},
    'nl': {'practiceModeTitle': 'Oefening', 'chatAiChat': 'Chat', 'tutorialAiChatTitle': 'Chat', 'helpMode3Desc': 'Oefen door te luisteren en na te spreken.', 'helpModeChatDesc': 'Spreek met personages om echte gesprekken te oefenen.'},
    'no': {'practiceModeTitle': 'Øvelse', 'chatAiChat': 'Chat', 'tutorialAiChatTitle': 'Chat', 'helpMode3Desc': 'Øv ved å lytte og gjenta.', 'helpModeChatDesc': 'Snakk med personaer for å øve på samtale.'},
    'or': {'practiceModeTitle': 'ଅଭ୍ୟାସ', 'chatAiChat': 'ଚାଟ୍', 'tutorialAiChatTitle': 'ଚାଟ୍', 'helpMode3Desc': 'ଶୁଣି ଏବଂ ଦୋହରାଇ ଅଭ୍ୟାସ କରନ୍ତୁ।', 'helpModeChatDesc': 'ପ୍ରକୃତ କଥାବାର୍ତ୍ତା ପାଇଁ ପାତ୍ରମାନଙ୍କ ସହ କଥା ହୁଅନ୍ତୁ।'},
    'pa': {'practiceModeTitle': 'ਅਭਿਆਸ', 'chatAiChat': 'ਚੈਟ', 'tutorialAiChatTitle': 'ਚੈਟ', 'helpMode3Desc': 'ਸੁਣ ਕੇ ਅਤੇ ਦੁਹਰਾ ਕੇ ਅਭਿਆਸ ਕਰੋ।', 'helpModeChatDesc': 'ਅਸਲੀ ਗੱਲਬਾਤ ਲਈ ਪਾਤਰਾਂ ਨਾਲ ਗੱਲ ਕਰੋ।'},
    'pl': {'practiceModeTitle': 'Praktyka', 'chatAiChat': 'Czat', 'tutorialAiChatTitle': 'Czat', 'helpMode3Desc': 'Ćwicz słuchając i powtarzając.', 'helpModeChatDesc': 'Rozmawiaj z postaciami, aby ćwiczyć rozmowę.'},
    'pt': {'practiceModeTitle': 'Prática', 'chatAiChat': 'Chat', 'tutorialAiChatTitle': 'Chat', 'helpMode3Desc': 'Pratique ouvindo e repetindo.', 'helpModeChatDesc': 'Fale com personagens para praticar conversas reais.'},
    'ro': {'practiceModeTitle': 'Practică', 'chatAiChat': 'Chat', 'tutorialAiChatTitle': 'Chat', 'helpMode3Desc': 'Exersează ascultând și repetând.', 'helpModeChatDesc': 'Vorbește cu personaje pentru a exersa conversația.'},
    'ru': {'practiceModeTitle': 'Практика', 'chatAiChat': 'Чат', 'tutorialAiChatTitle': 'Чат', 'helpMode3Desc': 'Практикуйтесь, слушая и повторяя.', 'helpModeChatDesc': 'Общайтесь с персонажами для практики реальной беседы.'},
    'si': {'practiceModeTitle': 'පුහුණුව', 'chatAiChat': 'චැට්', 'tutorialAiChatTitle': 'චැට්', 'helpMode3Desc': 'සවන් දී නැවත පැවසීමෙන් පුහුණු වන්න.', 'helpModeChatDesc': 'සැබෑ සංවාද සඳහා චරිත සමඟ කතා කරන්න.'},
    'sk': {'practiceModeTitle': 'Prax', 'chatAiChat': 'Chat', 'tutorialAiChatTitle': 'Chat', 'helpMode3Desc': 'Precvičujte počúvaním a opakovaním.', 'helpModeChatDesc': 'Hovorte s postavami pre nácvik skutočnej konverzácie.'},
    'sl': {'practiceModeTitle': 'Vaja', 'chatAiChat': 'Klepet', 'tutorialAiChatTitle': 'Klepet', 'helpMode3Desc': 'Vadite s poslušanjem in ponavljanjem.', 'helpModeChatDesc': 'Govorite z osebami za vajo pravega pogovora.'},
    'sq': {'practiceModeTitle': 'Praktikë', 'chatAiChat': 'Bisedë', 'tutorialAiChatTitle': 'Bisedë', 'helpMode3Desc': 'Praktikoni duke dëgjuar dhe përsëritur.', 'helpModeChatDesc': 'Falisni me personazhe për praktikë reale.'},
    'sr': {'practiceModeTitle': 'Вежба', 'chatAiChat': 'Ћаскање', 'tutorialAiChatTitle': 'Ћаскање', 'helpMode3Desc': 'Вежбајте слушајући и понављајући.', 'helpModeChatDesc': 'Разговарајте са ликовима за стварну вежбу.'},
    'sv': {'practiceModeTitle': 'Övning', 'chatAiChat': 'Chatt', 'tutorialAiChatTitle': 'Chatt', 'helpMode3Desc': 'Öva genom att lyssna och repetera.', 'helpModeChatDesc': 'Prata med karaktärer för att öva på riktiga samtal.'},
    'sw': {'practiceModeTitle': 'Mazoezi', 'chatAiChat': 'Gumzo', 'tutorialAiChatTitle': 'Gumzo', 'helpMode3Desc': 'Fanya mazoezi kwa kusikiliza na kurudia.', 'helpModeChatDesc': 'Zungumza na wahusika kufanya mazoezi ya mazungumzo.'},
    'ta': {'practiceModeTitle': 'பயிற்சி', 'chatAiChat': 'அரட்டை', 'tutorialAiChatTitle': 'அரட்டை', 'helpMode3Desc': 'கேட்டுத் திரும்பக் கூறிப் பயிற்சி செய்யுங்கள்.', 'helpModeChatDesc': 'உண்மை உரையாடலுக்குப் பாத்திரங்களுடன் பேசுங்கள்.'},
    'te': {'practiceModeTitle': 'అభ్యాసం', 'chatAiChat': 'చాట్', 'tutorialAiChatTitle': 'చాట్', 'helpMode3Desc': 'వింటూ మరియు తిరిగి చెబుతూ అభ్యాసం చేయండి.', 'helpModeChatDesc': 'నిజమైన సంభాషణ కోసం పాత్రలతో మాట్లాడండి.'},
    'th': {'practiceModeTitle': 'ฝึกฝน', 'chatAiChat': 'แชท', 'tutorialAiChatTitle': 'แชท', 'helpMode3Desc': 'ฝึกฝนโดยการฟังและพูดตาม', 'helpModeChatDesc': 'คุยกับตัวละครเพื่อฝึกสนทนาจริง'},
    'tl': {'practiceModeTitle': 'Pagsasanay', 'chatAiChat': 'Chat', 'tutorialAiChatTitle': 'Chat', 'helpMode3Desc': 'Magsanay sa pamamagitan ng pakikinig at pag-uulit.', 'helpModeChatDesc': 'Makipag-usap sa mga persona para sa tunay na usapan.'},
    'tr': {'practiceModeTitle': 'Pratik', 'chatAiChat': 'Sohbet', 'tutorialAiChatTitle': 'Sohbet', 'helpMode3Desc': 'Dinleyerek ve tekrarlayarak pratik yapın.', 'helpModeChatDesc': 'Gerçek konuşma pratiği için karakterlerle konuşun.'},
    'uk': {'practiceModeTitle': 'Практика', 'chatAiChat': 'Чат', 'tutorialAiChatTitle': 'Чат', 'helpMode3Desc': 'Практикуйтеся, слухаючи та повторюючи.', 'helpModeChatDesc': 'Спілкуйтеся з персонажами для практики реальної розмови.'},
    'ur': {'practiceModeTitle': 'مشق', 'chatAiChat': 'چیٹ', 'tutorialAiChatTitle': 'چیٹ', 'helpMode3Desc': 'سن کر اور دہرا کر مشق کریں۔', 'helpModeChatDesc': 'حقیقی گفتگو کی مشق کے لیے کرداروں سے بات کریں۔'},
    'uz': {'practiceModeTitle': 'Mashq', 'chatAiChat': 'Chat', 'tutorialAiChatTitle': 'Chat', 'helpMode3Desc': 'Eshitib va takrorlab mashq qiling.', 'helpModeChatDesc': 'Haqiqiy suhbat uchun personajlar bilan gaplashing.'},
    'vi': {'practiceModeTitle': 'Luyện tập', 'chatAiChat': 'Trò chuyện', 'tutorialAiChatTitle': 'Trò chuyện', 'helpMode3Desc': 'Luyện tập bằng cách nghe và lặp lại.', 'helpModeChatDesc': 'Nói chuyện với nhân vật để luyện hội thoại thực tế.'},
    'zh': {'practiceModeTitle': '练习', 'chatAiChat': '聊天', 'tutorialAiChatTitle': '聊天', 'helpMode3Desc': '通过听和跟读进行练习。', 'helpModeChatDesc': '与角色对话练习实战会话。'},
    'zh_CN': {'practiceModeTitle': '练习', 'chatAiChat': '聊天', 'tutorialAiChatTitle': '聊天', 'helpMode3Desc': '通过听和跟读进行练习。', 'helpModeChatDesc': '与角色对话练习实战会话。'},
    'zh_TW': {'practiceModeTitle': '練習', 'chatAiChat': '聊天', 'tutorialAiChatTitle': '聊天', 'helpMode3Desc': '透過聽和跟讀進行練習。', 'helpModeChatDesc': '與角色對話練習實戰會話。'},
    'CN': {'practiceModeTitle': '练习', 'chatAiChat': '聊天', 'tutorialAiChatTitle': '聊天', 'helpMode3Desc': '通过听和跟读进行练习。', 'helpModeChatDesc': '与角色对话练习实战会话。'},
    'TW': {'practiceModeTitle': '練習', 'chatAiChat': '聊天', 'tutorialAiChatTitle': '聊天', 'helpMode3Desc': '透過聽和跟讀進行練習。', 'helpModeChatDesc': '與角色對話練習實戰會話。'},
    'zu': {'practiceModeTitle': 'Ukuzijwayeza', 'chatAiChat': 'Ingxoxo', 'tutorialAiChatTitle': 'Ingxoxo', 'helpMode3Desc': 'Zijwayeze ngokulalela nokuphinda.', 'helpModeChatDesc': 'Khuluma nabalingiswa ukuze uzijwayeze ingxoxo.'}
  };

  for (final file in files) {
    if (file.path.contains('app_ko.arb')) continue; 
    
    final fileName = file.path.split(Platform.pathSeparator).last;
    final langCode = fileName.split('_').last.replaceAll('.arb', '');
    
    if (l10nData.containsKey(langCode)) {
      try {
        final content = await file.readAsString();
        final Map<String, dynamic> map = jsonDecode(content);
        final updates = l10nData[langCode]!;
        
        updates.forEach((key, value) {
          map[key] = value;
        });
        
        const encoder = JsonEncoder.withIndent('  ');
        await file.writeAsString(encoder.convert(map));
        print('✅ Sync complete for: $langCode');
      } catch (e) {
        print('❌ Error in $langCode: $e');
      }
    } else {
      print('⚠️ No data for: $langCode');
    }
  }
}
