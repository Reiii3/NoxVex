## AxVision Update v1047-070726-S

> This update focuses on optimizing the plugin, including the WebUI, engine, and various internal components. It reflects our continuous commitment to improving AxVision. We have now reached version **1047-070726-S**, which was not an easy milestone. Throughout development, our team encountered and resolved numerous bugs before this release was finally ready. Below are the major changes included in this update.

### - Engine Improvements

> Several issues were found in the engine, particularly affecting the `Frame Rate` and `Game Driver` functions. These bugs have now been fixed, allowing both features to operate normally again.

### - New Features in Engine v1042

> We have introduced several new features in Engine v1042:

* **Multitask Mode**

  > This feature allows you to control the amount of RAM that background applications can use, helping improve memory efficiency and overall multitasking performance.

* **CMD Tweak**

  > CMD Tweak is based on the original CMD optimization from the AxManager plugin. Thanks to its open-source implementation, we were able to integrate this feature into the AxVision engine. Special thanks to **[HoyoSlave](https://t.me/HoyoSlave)** for the original work.

* **Smart Compact**

  > Smart Compact helps reduce RAM fragmentation, improves large memory allocation, and increases overall memory efficiency.

* **Auto Cut Charging** `For OPPO Devices`

  > This feature is specifically designed for OPPO devices. It enables the built-in Auto Cut Charging system when supported by the device, allowing users to play games while charging with greater peace of mind. The engine will automatically activate this feature once the charging threshold is reached.

* **Profile Protect**

  > Profile Protect is a mechanism developed to automatically switch performance profiles when the device temperature rises. This helps maintain stable performance while preventing excessive heat.

* **And Many More Features**

  > Additional improvements and new features have also been added throughout the engine.

### - New Features in Game Library

> In the previous **v1045** update, we accidentally omitted the Game Library configuration. At that time, the update shipped with Engine **v1036**, which did not yet include the necessary configuration. During our Engine **v1038** testing through **Daemon Monitor**, we successfully completed the implementation. As a result, features such as `Game Driver`, `Graphic Scale`, and `Frame Rate` became available.

#### New Addition

* **Dynamic Frame Rate**

  > With this feature, users no longer need to manually configure the Frame Rate setting. Our WebUI can now automatically detect the highest supported frame rate available on your device.

### - WebUI Updates

> This is the largest UI update we have ever released for AxVision. We've made significant improvements across multiple areas.

* **New UI Theme**

  > We admit that the UI in **v1045** was not well optimized and felt too heavy for entry-level devices. In this release, we redesigned the interface using an **Android 16-inspired** color theme while making it cleaner and more responsive.

* **WebUI Optimization**

  > The optimization in v1045 was far from ideal. After extensive maintenance, we successfully eliminated approximately **70%** of the bottlenecks responsible for UI lag, resulting in a much smoother experience.

* **UI Branding**

  > Previous releases did not have a dedicated UI name. Starting from versions **1045** and **1047**, the interface is officially branded as **VISIONUI** version **10200-UI**. This naming system helps simplify future maintenance and version management.

* **And Many More Improvements**

  > There are many additional refinements throughout the interface that you can explore yourself.

### - About Available Features

> **Available Features** is our solution for delivering new functionality without requiring users to update the entire plugin. Instead, we only need to update the engine version, allowing newly released online patches to unlock additional features automatically. We hope this approach makes it easier for everyone to enjoy new functionality without downloading a full plugin update.

---

> There is still a lot more we could explain about this release, as it is one of the biggest updates we've ever worked on. However, I'll keep it brief since I'm honestly feeling a bit under the weather while writing this changelog. I hope you all understand.
>
> Finally, I would like to sincerely thank everyone for supporting **AxVision**. We have now reached over **7,000 users**, and seeing the community continue to grow means a lot to us.
>
> **Thank you for your continued support! 😊**
