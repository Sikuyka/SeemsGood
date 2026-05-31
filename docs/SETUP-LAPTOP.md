# SeemsGood на ноутбуке — Rojo + Studio (полная инструкция)

Для пользователя с Rojo в `C:\Users\luxaeterna\Desktop\tools\`

---

## Часть 1. Плагин Rojo в Roblox Studio

### Способ A (рекомендуется)

1. Откройте в браузере:  
   https://create.roblox.com/marketplace/asset/13916111004/Rojo  
2. Нажмите **Install** / **Установить** (нужен вход в Roblox).  
3. Откройте **Roblox Studio** → вкладка **Plugins** — должен появиться **Rojo**.

### Способ B (через ваш rojo.exe)

В PowerShell:

```powershell
& "C:\Users\luxaeterna\Desktop\tools\rojo.exe" plugin install
```

Перезапустите Studio.

---

## Часть 2. Скачать проект с GitHub

В PowerShell:

```powershell
cd $env:USERPROFILE\Desktop
git clone https://github.com/Sikuyka/SeemsGood.git
cd SeemsGood
git checkout cursor/seemsgood-full-game-b0be
```

Если нет **git**: установите https://git-scm.com/download/win и повторите команды.

**Без git:** на https://github.com/Sikuyka/SeemsGood нажмите **Code → Download ZIP**, распакуйте в `Desktop\SeemsGood`.

---

## Часть 3. Запустить Rojo и подключить Studio

1. PowerShell (окно **не закрывать**):

```powershell
cd $env:USERPROFILE\Desktop\SeemsGood
& "C:\Users\luxaeterna\Desktop\tools\rojo.exe" serve
```

Должно появиться:

```text
Rojo server listening:
  Port:    34872
```

2. Roblox Studio → **New** (любой baseplate) или откройте place.  
3. **Plugins** → **Rojo** → **Connect**.  
4. Дождитесь синка (дерево Explorer заполнится: ReplicatedStorage, ServerScriptService, …).  
5. **File → Save to File** — сохраните place как `SeemsGood.rbxl` (по желанию).  
6. **Play (F5)** — в Output: `[SeemsGood] All services started.`

---

## Часть 4. DataStore в Studio

**Home → Game Settings → Security** → включите:

**Enable Studio Access to API Services**

Иначе сохранения не заработают.

---

## Каждый раз при работе

1. `rojo serve` в папке `SeemsGood` (окно открыто).  
2. Studio → Rojo → **Connect**.  
3. Кодите / Play.

---

## Проблемы

| Симптом | Решение |
|---------|---------|
| Нет Plugins → Rojo | Установите с маркетплейса (Часть 1A) |
| Connect не работает | Сначала `rojo serve`, потом Connect |
| Пустой Explorer | Неверная папка — нужен `default.project.json` внутри |
| `git` не найден | Git for Windows или ZIP с GitHub |

---

## Ваши пути

| Что | Путь |
|-----|------|
| Rojo CLI | `C:\Users\luxaeterna\Desktop\tools\rojo.exe` |
| Проект | `C:\Users\luxaeterna\Desktop\SeemsGood` |
| Ветка с игрой | `cursor/seemsgood-full-game-b0be` |
