## 🚀 Version 1052-180926-S Update | Engine Rewrite

> This update focuses on rebuilding or rewriting the program code for the Engine Daemon and its CLI. With this, we hope to reduce previous bugs. Additionally, with this rewrite, we have reconfigured the tweaks by adding and removing certain tweak codes. We hope this makes this version of the daemon more optimal.

## 🧠 Daemon Structure Rewrite

> We have implemented a series of new structural builds on the new daemon, specifically version 10120-UFG-S. In this version, we are using the structure model from our new plugin, Qiunix: Apollo. This model utilizes our latest structure design, which is proven to be faster in its mode response and allows tweak maintenance to be handled in a more structured manner.

## 🦾 System Feature Function Updates

> We have reconfigured several system functions in the daemon using the latest function model from the Qiunix: Apollo plugin by rewriting the code and replacing it with the new plugin's code model.

**Some of the functions we have updated include:**

* **Background Reaper:** Previously, the background reaper performed a mass `force-stop` on background applications without checking the RAM usage of those apps. This caused system failures, forced the CPU to work excessively hard to execute the force-stops, and also triggered system launcher crashes, which made the device's System UI unresponsive and resulted in UI errors.
* **Auto Thermal Calculation:** Added thermal calculations so the system does not overheat while playing games, which would otherwise cause throttling in game rendering. To address this, we implemented a calculation function assisted by the Opus 5 AI model. With this, the thermals will adjust automatically, minimizing thermal system errors.
* **Smart RAM Cleaning:** Added kernel-level memory cache cleaning (`drop_caches`) executed right before the game is launched to provide maximum free RAM and prevent freezing during the initial loading screen (Root Only).
* **Anti-Zombie Background Reaper:** Implemented an atomic Lock-File mechanism (`vision_reaper.lock`) to prevent background cleaning loops from overlapping when the user quickly switches between applications.
* **Dynamic Root Detection:** Updated the root checking system to directly test write access on active CPU clusters, ensuring the OS's built-in thermal protection is not accidentally disabled in Shizuku/non-root setups.
* **POSIX-Safe Date Parsing:** Consolidated time-checking commands to be executed only once per loop, significantly saving battery power and reducing processing load (overhead).

---

## 🔧 Additional Fixes

* **Adaptive Polling (`game_stable_loops`):** The daemon now intelligently adjusts its delay time (from 3 seconds to 15 seconds) once the in-game status becomes stable.
* Replaced the heavy `dumpsys window` command spam with a layered and cached foreground app detection system.
* Minor bug fixes and overall system stability improvements.

> Thank you for using our system. Stay tuned for future updates that will bring more exciting improvements and new features.