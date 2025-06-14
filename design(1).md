
# مشروع تطوير لعبة RPG شبيهة بـ "الفتح: طريق الانتقام"

## الفكرة العامة:
إنشاء لعبة MMORPG تعمل على المتصفح و Android، مستوحاة من "الفتح: طريق الانتقام"، باستخدام مشروع Silkroad-online كنقطة انطلاق. اللعبة تشمل تحكم بالشخصية، قتال تلقائي، نظام مهمات، واجهات شاملة، ونظام إدارة سيرفر كامل.

---

## المطلوب من Copilot Agent:

### المرحلة 1: تجهيز المشروع
- تأكد من تنصيب كل التبعيات.
- نظم المشروع بإضافة:
  - مجلد `game_data/` لتخزين الخرائط، الشخصيات، الوحوش، الأسلحة.
  - مجلد `scripts/` لأنظمة الذكاء الاصطناعي، المهمات، القتال، المهارات.
  - مجلد `ui/` لواجهة المستخدم.
  - مجلد `assets/` للأصوات والصور والمؤثرات.

---

### المرحلة 2: منطق اللعبة

#### تحكم الشخصية:
- أضف **Joystick افتراضي** (موبايل) و**WASD** (متصفح).
- دعم **Auto-Walk** للمهمات: عند الضغط على زر المهمة، تتحرك الشخصية تلقائياً نحو الهدف.

#### القتال:
- **Auto Attack Mode**:
  - عند دخول منطقة وحوش، تبدأ الشخصية تلقائيًّا بمهاجمتهم.
  - استخدام الهجوم العادي والمهارات تبعًا للـ cooldown.
  - زر تشغيل/إيقاف auto-mode في الواجهة.

#### نظام القتال:
- دعم المعارك الفردية والجماعية.
- health bar + damage numbers.
- مؤثرات لكل مهارة (تأثير بصري وصوتي).
- استخدام الخوارزميات لمتابعة مسافة اللاعب والعدو واتخاذ قرار الهجوم أو التراجع.

#### الذكاء الاصطناعي (AI):
- NPC ثابت بمواقع محددة.
- وحوش تتحرك وتهاجم تلقائياً إن اقترب اللاعب.
- نظام Aggro & Patrol.

---

### المرحلة 3: المهام والتقدم
- واجهة تعرض قائمة المهام.
- المهام تُسلم إلى NPC.
- عند الضغط على المهمة: auto-walk.
- مكافآت: EXP, Gold, Items.
- ملفات YAML لتخزين بيانات المهام.

---

### المرحلة 4: واجهات المستخدم (UI)
- شاشة رئيسية (تسجيل - دخول - اختيار شخصية).
- واجهة داخل اللعبة:
  - إنفنتوري
  - الخريطة المصغرة
  - مهارات
  - قائمة المهام
  - Auto Mode
- واجهة متجر (Shop).
- واجهة الشحن (In-App Purchases).
- واجهة VIP ومستويات الامتيازات.

---

### المرحلة 5: الأنظمة المتقدمة

#### VIP:
- رتب VIP وامتيازاتها (نقاط أكثر، سرعة، مهارات).
- نظام شحن مرتبط بزيادة المستوى.

#### Guild System:
- إنشاء / الانضمام لتحالف.
- دردشة جماعية.
- أحداث جماعية.

#### PvP / Arena:
- دعم معارك لاعب ضد لاعب.
- تسجيل دخول إلى ساحة المعركة.
- نظام مكافآت للفوز.

#### الأحداث Events:
- أحداث تلقائية (كل ساعة/يوم).
- أحداث Boss.
- هدايا تسجيل الدخول.

---

### المرحلة 6: السيرفر و API
- مجلد backend يحتوي:
  - API لتسجيل الدخول، تسجيل، إدارة الحساب.
  - قواعد بيانات (SQLite محلي).
  - سكربتات للمهمات والقتال والشخصيات.
  - WebSocket أو REST API لتبادل البيانات مع العميل.

---

### المرحلة 7: أدوات الإدارة

#### لوحة تحكم Admin:
- لوحة على الويب لإدارة:
  - الحسابات
  - اللاعبين
  - إرسال الهدايا
  - تعديل العناصر
  - متابعة السجلات

#### أوامر GM:
- Teleport
- إضافة ذهب/عناصر
- كتم/طرد
- تفعيل حدث

---

### المرحلة 8: الموارد والأصول
- ملفات JSON/YAML:
  - الشخصيات
  - الوحوش
  - الأسلحة/الدروع
  - المهارات
  - المهام
- الأصوات: ضرب، سحر، نصر، موت.
- الرسوم: idle/run/attack/death لكل شخصية/وحش.
- مؤثرات FX.

---

## المطلوب من Agent:
- تنفيذ النقاط السابقة خطوة بخطوة.
- إنشاء الملفات تلقائياً.
- استخدام Flutter و Egret أو HTML5 Canvas للرندر.
- كتابة سكربتات منظمة في مجلد `scripts/`.
- تنبيه عند وجود نقص أو تعارض.
