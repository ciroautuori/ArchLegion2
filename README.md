# ArchLegion2: Kit di Ottimizzazione One-Liner per Lenovo Legion Y520

## Missione: Ottimizzazione Totale con un Singolo Comando

Questo repository è stato perfezionato per offrire un'esperienza di installazione **completamente automatizzata**. Dimentica le guide manuali: con un singolo comando, puoi trasformare un'installazione pulita di Arch Linux sul tuo Lenovo Legion Y520 in una macchina da calcolo ad alte prestazioni.

---

## Installazione One-Liner (Metodo Definitivo)

Apri un terminale su un'installazione di Arch Linux con accesso a internet ed esegui questo comando. Lo script si occuperà di tutto: dall'installazione dei pacchetti all'applicazione delle configurazioni più raffinate.

```bash
bash <(curl -sSL https://raw.githubusercontent.com/CiroAutuori/ArchLegion2/main/scripts/bootstrap.sh)
```

**Cosa fa questo comando?**
1.  Scarica ed esegue uno script di bootstrap.
2.  Lo script di bootstrap clona questo repository in una directory temporanea.
3.  Viene eseguito lo script di setup principale (`setup.sh`) con i privilegi necessari.
4.  Lo script `setup.sh` installa tutti i pacchetti, le dipendenze (da pacman e AUR), copia tutti i file di configurazione e attiva i servizi.
5.  Al termine, ti verrà chiesto di riavviare il sistema per completare il processo.

---
## Struttura del Repository

- **/config**: Contiene una copia esatta di tutti i file di configurazione necessari per le ottimizzazioni, organizzati nella loro struttura di directory originale.
- **/scripts**: Contiene gli script di automazione.
  - `bootstrap.sh`: Lo script di avvio leggero, punto d'ingresso per l'installazione one-liner.
  - `setup.sh`: Il cuore dell'automazione. Uno script robusto che esegue tutte le operazioni di installazione e configurazione.
- `README.md`: Questa guida.

---

## Dettaglio delle Ottimizzazioni (Manuale Tecnico)

Questa sezione documenta in dettaglio ogni modifica apportata dallo script di installazione.

## Missione: Massima Performance su Arch Linux

Questo repository non è solo una guida, ma un **kit di installazione completo e automatizzato** per trasformare un Lenovo Legion Y520 in una macchina da calcolo ad alte prestazioni su Arch Linux.

---

## Installazione Automatica (Metodo Consigliato)

Per replicare questa configurazione ottimizzata su un'installazione pulita di Arch Linux, segui questi semplici passaggi:

1.  **Clona il repository:**
    ```bash
    git clone https://github.com/tuo-utente/ArchLegion2.git
    cd ArchLegion2
    ```

2.  **Esegui lo script di setup:**
    Lo script installerà tutti i pacchetti necessari, applicherà le configurazioni e attiverà i servizi.
    ```bash
    cd scripts
    sudo ./setup.sh
    ```

3.  **Riavvia il sistema:**
    Una volta completato lo script, riavvia il computer per rendere effettive tutte le modifiche.
    ```bash
    sudo reboot
    ```

---

## Dettaglio delle Ottimizzazioni

Questa sezione documenta in dettaglio ogni modifica apportata dallo script di installazione.

### 1. Gestione Termica e Energetica (CPU & Ventole)

#### 1.1. Undervolting della CPU
- **Obiettivo:** Ridurre il voltaggio della CPU per diminuire le temperature e il consumo energetico, consentendo al processore di mantenere frequenze di boost più elevate per periodi prolungati.
- **Strumento:** `undervolt`
- **Configurazione:** -125mV su Core e Cache.
- **Automazione:** Un servizio systemd (`/etc/systemd/system/undervolt.service`) applica le impostazioni all'avvio e al risveglio dalla sospensione.
- **Verifica:**
  ```bash
  undervolt --read
  ```

#### 1.2. Controllo Manuale delle Ventole
- **Obiettivo:** Fornire un controllo diretto sulla velocità delle ventole per massimizzare il raffreddamento during le operazioni più esigenti.
- **Strumento:** `ExtremeCooling4Linux`
- **Utilizzo:**
  - **Attiva Raffreddamento Estremo:** `ec4Linux enable`
  - **Disattiva Raffreddamento Estremo:** `ec4Linux disable`
  - **Inverti Stato:** `ec4Linux change-state`
- **Nota:** Questa modalità è rumorosa e va usata solo quando le performance sono critiche.

#### 1.3. CPU Governor
- **Obiettivo:** Mantenere la CPU costantemente alla massima frequenza per eliminare la latenza introdotta dal cambio di stato.
- **Configurazione:** `performance` governor impostato tramite `/etc/default/cpupower`.

### 2. Ottimizzazione del Sottosistema Grafico (GPU)

#### 2.1. Modalità Massime Prestazioni NVIDIA
- **Obiettivo:** Impedire alla GPU NVIDIA di entrare in stati di risparmio energetico, garantendo sempre la massima potenza di calcolo disponibile.
- **Metodo:** Configurazione Xorg (`/etc/X11/xorg.conf.d/20-nvidia-perf.conf`) e script di avvio (`~/.local/bin/nvidia-perf.sh`).
- **Verifica:**
  ```bash
  nvidia-smi -q -d PERFORMANCE | grep "Performance State"
  ```
  (Lo stato `P0` indica le massime prestazioni).

#### 2.2. Accelerazione Hardware per Applicazioni Electron
- **Obiettivo:** Forzare l'uso della GPU per il rendering delle interfacce di applicazioni basate su Electron (Windsurf/Cascade, Obsidian, Chrome), liberando la CPU.
- **Metodo:** Aggiunta di flag specifici (`--ignore-gpu-blocklist`, `--enable-gpu-rasterization`, etc.) nei file `.desktop` delle applicazioni e in `~/.config/electron34-flags.conf`.

### 3. Ottimizzazione del Sistema Operativo

#### 3.1. I/O Scheduler per SSD
- **Obiettivo:** Ridurre la latenza di accesso al disco per sistemi con SSD.
- **Configurazione:** `mq-deadline` impostato tramite una regola udev (`/etc/udev/rules.d/60-ioschedulers.rules`).

#### 3.2. Gestione della Memoria (Swappiness)
- **Obiettivo:** Prioritizzare l'uso della RAM rispetto al file di swap per migliorare la reattività generale del sistema.
- **Configurazione:** `vm.swappiness=10` impostato in `/etc/sysctl.d/99-swappiness.conf`.

#### 3.3. RAMDisk per la Cache del Browser
- **Obiettivo:** Spostare la cache del browser su un disco virtuale in RAM per velocizzare la navigazione e ridurre l'usura dell'SSD.
- **Configurazione:** Mount `tmpfs` in `/etc/fstab` e modifica dei file `.desktop` del browser per usare la nuova directory.

#### 3.4. Compilazione Parallela
- **Obiettivo:** Sfruttare tutti i core della CPU per accelerare la compilazione di pacchetti dall'AUR.
- **Configurazione:** `MAKEFLAGS="-j8"` in `/etc/makepkg.conf`.

#### 3.5. Ottimizzazione del Compositor
- **Obiettivo:** Ridurre il carico sulla GPU disattivando effetti grafici pesanti.
- **Configurazione:** Modifiche al file di configurazione di `picom` (`~/.config/picom/picom.conf`) per disabilitare ombre, trasparenze e sfocature.

---

## Guida Rapida all'Uso (Post-Installazione)

Questo sistema è progettato per essere "imposta e dimentica" per la maggior parte delle ottimizzazioni. L'unica interazione manuale richiesta è per il controllo delle ventole.

- **Uso Quotidiano:** Il sistema opera in modalità ad alte prestazioni ma con ventole automatiche.
- **Sessioni Intensive:** Prima di avviare Ollama, un gioco o una compilazione pesante, lancia questo comando nel terminale:
  ```bash
  ec4Linux enable
  ```
- **Fine Sessione:** Una volta terminata l'attività, riporta le ventole alla normalità per un funzionamento silenzioso:
  ```bash
  ec4Linux disable
  ```

Questo approccio bilancia perfettamente performance estreme on-demand e comfort acustico durante l'uso normale.

## Missione: Massima Performance su Arch Linux

Questo repository documenta il processo di trasformazione di un Lenovo Legion Y520 in una macchina da calcolo ad alte prestazioni, ottimizzata per carichi di lavoro intensivi come lo sviluppo di IA con Ollama, il gaming e la compilazione di software. Ogni modifica è stata studiata per estrarre la massima potenza dall'hardware, mantenendo al contempo la stabilità del sistema.

---

## Indice delle Ottimizzazioni

### 1. Gestione Termica e Energetica (CPU & Ventole)

#### 1.1. Undervolting della CPU
- **Obiettivo:** Ridurre il voltaggio della CPU per diminuire le temperature e il consumo energetico, consentendo al processore di mantenere frequenze di boost più elevate per periodi prolungati.
- **Strumento:** `undervolt`
- **Configurazione:** -125mV su Core e Cache.
- **Automazione:** Un servizio systemd (`/etc/systemd/system/undervolt.service`) applica le impostazioni all'avvio e al risveglio dalla sospensione.
- **Verifica:**
  ```bash
  undervolt --read
  ```

#### 1.2. Controllo Manuale delle Ventole
- **Obiettivo:** Fornire un controllo diretto sulla velocità delle ventole per massimizzare il raffreddamento durante le operazioni più esigenti.
- **Strumento:** `ExtremeCooling4Linux`
- **Utilizzo:**
  - **Attiva Raffreddamento Estremo:** `ec4Linux enable`
  - **Disattiva Raffreddamento Estremo:** `ec4Linux disable`
  - **Inverti Stato:** `ec4Linux change-state`
- **Nota:** Questa modalità è rumorosa e va usata solo quando le performance sono critiche.

#### 1.3. CPU Governor
- **Obiettivo:** Mantenere la CPU costantemente alla massima frequenza per eliminare la latenza introdotta dal cambio di stato.
- **Configurazione:** `performance` governor impostato tramite `/etc/default/cpupower`.

### 2. Ottimizzazione del Sottosistema Grafico (GPU)

#### 2.1. Modalità Massime Prestazioni NVIDIA
- **Obiettivo:** Impedire alla GPU NVIDIA di entrare in stati di risparmio energetico, garantendo sempre la massima potenza di calcolo disponibile.
- **Metodo:** Configurazione Xorg (`/etc/X11/xorg.conf.d/20-nvidia-perf.conf`) e script di avvio (`~/.local/bin/nvidia-perf.sh`).
- **Verifica:**
  ```bash
  nvidia-smi -q -d PERFORMANCE | grep "Performance State"
  ```
  (Lo stato `P0` indica le massime prestazioni).

#### 2.2. Accelerazione Hardware per Applicazioni Electron
- **Obiettivo:** Forzare l'uso della GPU per il rendering delle interfacce di applicazioni basate su Electron (Windsurf/Cascade, Obsidian, Chrome), liberando la CPU.
- **Metodo:** Aggiunta di flag specifici (`--ignore-gpu-blocklist`, `--enable-gpu-rasterization`, etc.) nei file `.desktop` delle applicazioni e in `~/.config/electron34-flags.conf`.

### 3. Ottimizzazione del Sistema Operativo

#### 3.1. I/O Scheduler per SSD
- **Obiettivo:** Ridurre la latenza di accesso al disco per sistemi con SSD.
- **Configurazione:** `mq-deadline` impostato tramite una regola udev (`/etc/udev/rules.d/60-ioschedulers.rules`).

#### 3.2. Gestione della Memoria (Swappiness)
- **Obiettivo:** Prioritizzare l'uso della RAM rispetto al file di swap per migliorare la reattività generale del sistema.
- **Configurazione:** `vm.swappiness=10` impostato in `/etc/sysctl.d/99-swappiness.conf`.

#### 3.3. RAMDisk per la Cache del Browser
- **Obiettivo:** Spostare la cache del browser su un disco virtuale in RAM per velocizzare la navigazione e ridurre l'usura dell'SSD.
- **Configurazione:** Mount `tmpfs` in `/etc/fstab` e modifica dei file `.desktop` del browser per usare la nuova directory.

#### 3.4. Compilazione Parallela
- **Obiettivo:** Sfruttare tutti i core della CPU per accelerare la compilazione di pacchetti dall'AUR.
- **Configurazione:** `MAKEFLAGS="-j8"` in `/etc/makepkg.conf`.

#### 3.5. Ottimizzazione del Compositor
- **Obiettivo:** Ridurre il carico sulla GPU disattivando effetti grafici pesanti.
- **Configurazione:** Modifiche al file di configurazione di `picom` (`~/.config/picom/picom.conf`) per disabilitare ombre, trasparenze e sfocature.

---

## Guida Rapida all'Uso

Questo sistema è progettato per essere "imposta e dimentica" per la maggior parte delle ottimizzazioni. L'unica interazione manuale richiesta è per il controllo delle ventole.

- **Uso Quotidiano:** Il sistema opera in modalità ad alte prestazioni ma con ventole automatiche.
- **Sessioni Intensive:** Prima di avviare Ollama, un gioco o una compilazione pesante, lancia questo comando nel terminale:
  ```bash
  ec4Linux enable
  ```
- **Fine Sessione:** Una volta terminata l'attività, riporta le ventole alla normalità per un funzionamento silenzioso:
  ```bash
  ec4Linux disable
  ```

Questo approccio bilancia perfettamente performance estreme on-demand e comfort acustico durante l'uso normale.

Welcome to the official ArchLegion2 guide. This repository provides a comprehensive, professional, and up-to-date guide for installing, configuring, and optimizing Arch Linux on the Lenovo Legion Y520. It includes options for both a fully automated installation and a detailed manual guide.

---

## 🚀 Automated Installation (Recommended Method)

For the fastest and easiest setup, use our powerful automation scripts. This is the recommended path for most users.

### Quick Steps:

1.  **Boot** the Arch Linux live environment.
2.  **Connect** to the internet.
3.  **Clone this repository**:
    ```bash
    git clone https://github.com/your-username/ArchLegion2.git
    ```
4.  **Run the automated installer**:
    ```bash
    archinstall --config ArchLegion2/scripts/user_configuration.json
    ```
5.  **After rebooting**, run the post-install script:
    ```bash
    cd ArchLegion2/scripts && sudo ./post_install.sh
    ```

For a complete walkthrough of this process, please see the [**Full Automated Installation Guide**](./docs/07-Automated-Installation.md).

---

## 📖 Manual Installation Guide

For advanced users who prefer complete control over every step of the process, we provide a detailed manual installation guide.

### Table of Contents

1.  [**Introduction**](./docs/01-Introduction.md)
2.  [**Pre-Installation**](./docs/02-Pre-Installation.md) (Dual-Boot Setup)
3.  [**Base Installation**](./docs/03-Base-Installation.md)
4.  [**System Configuration**](./docs/04-System-Configuration.md)
5.  [**Post-Installation & Optimization**](./docs/05-Post-Installation.md) (NVIDIA & CPU Fixes)
6.  [**Troubleshooting & FAQ**](./docs/06-Troubleshooting.md)

---

## How to Contribute

Contributions are welcome! Please read our [Contributing Guidelines](./CONTRIBUTING.md) to get started.

## License

This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.
