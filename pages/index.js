import Link from "@docusaurus/Link";
import useDocusaurusContext from "@docusaurus/useDocusaurusContext";
import Layout from "@theme/Layout";
import clsx from "clsx";
import React from "react";
import "./home.css";
import styles from "./index.module.css";

const FEATURES = [
  {
    image: "https://cdn.discordapp.com/attachments/997871955199926386/1011749934963376198/carbonRemoteEvent.png",
    title: "Simple & Extensive API",
    description: (
      <>
        NeoNet is designed in a way to remove objects and instances from your code,
        and just let you use the Id's or names of remote objects to control them.
        <br />
        <br />
        Here's an example of what a RemoteEvent would look like on the Client & Server.
         You actually don't even need the :RemoteEvent() statement in here because
         :Connect() already calls it. 
        <br />
        <br />
        The RemoteEvent and RemoteFunction functions are only necessary
         because the server needs to create the instances before,
         or less than 10 seconds after the client tries to access it.
         However RemoteValues need to be initiated to have a starting value.
      </>
    ),
  },
  {
    image: "https://cdn.discordapp.com/attachments/997871955199926386/1011753612860473365/carbonMiddleware.png",
    title: "Built-in Middleware",
    description: (
      <>
        Neonet comes with two basic built-in middleware options:
        <br />
        RateLimiter: Basic rate limiter that will drop requests that are too early for the rate.
        <br />
        <br />
        TypeChecker: Also basic type checker where the user only needs to define the types that would return from typeof().
        <br />
        <br />
        Creating your own custom middleware isn't difficult either, you can checkout the <a href="https://neond00m.github.io/NeoNet/api/NeoNet#RemoteClientMiddleware">types </a>
        to understand the arguments and return parameters, or the docs page <a href="https://neond00m.github.io/NeoNet/docs/CustomMiddleware">here</a>.
      </>
    ),
  },
//   {
//     Art: () => (
//       <div>
//         <div className={styles.event}>
//           <p className={styles.frameTitle}>
//             All systems run in a fixed order, every frame
//           </p>
//           <div>
//             <h4>RenderStepped</h4>
//             <span>moveCutSceneCamera</span>
//             <span>animateModels</span>
//             <span>camera3dEffects</span>
//           </div>
//           <div>
//             <h4>Heartbeat</h4>
//             <span>spawnEnemies</span>
//             <span>poisonEnemies</span>
//             <span>enemiesMove</span>
//             <span>fireWeapons</span>
//             <span>doors</span>
//           </div>
//         </div>
//       </div>
//     ),
//     title: "Robust and Durable",
//     description: (
//       <>
//         Event-driven code can be sensitive to ordering issues and new behaviors
//         can be created accidentally. With ECS, your code runs contiguously in a
//         fixed order every frame, which makes it much more predictable and
//         resilient to new behaviors caused by refactors.
//         <br />
//         <br />
//         All systems have access to all the data in the game, which means adding
//         a new feature is as simple as creating a new system that simply declares
//         something about the world.
//       </>
//     ),
//   },
];

function Feature({ image, title, description, Art }) {
  return (
    <div className={styles.feature}>
      {image && <img className={styles.featureSvg} alt={title} src={image} />}
      {Art && <Art className={styles.featureSvg} />}
      <div className={styles.featureDescription}>
        <h3>{title}</h3>
        <p>{description}</p>
      </div>
    </div>
  );
}

export function HomepageFeatures() {
  if (!FEATURES) return null;

  return (
    <section>
      <div className="container">
        <div className={styles.features}>
          {FEATURES.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}

function HomepageHeader() {
  const { siteConfig } = useDocusaurusContext();
  return (
    <header className={clsx("hero", styles.heroBanner)}>
      <div className="container">
        <h1 className="hero__title">
          <img
            src={"https://cdn.discordapp.com/attachments/997871955199926386/1011766015857799178/NeoNetLogoFull.png"}
            className="bigLogo"
            alt="NeoNet"
          />
        </h1>
        <p className="hero__subtitle">{siteConfig.tagline}</p>
        <div className={styles.buttons}>
          <Link
            className="button button--secondary button--lg"
            to="/docs/intro"
          >
            Get Started →
          </Link>
        </div>
      </div>
    </header>
  );
}

export default function Home() {
  const { siteConfig, tagline } = useDocusaurusContext();
  return (
    <Layout title={siteConfig.title} description={tagline}>
      <HomepageHeader />
      <main>
        <p className={styles.tagline}>
            NeoNet is a networking module for Roblox. It simplifies the process of networking while also providing more utility. 
        </p>
        <HomepageFeatures />
      </main>
    </Layout>
  );
}