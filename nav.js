const nav = `
<header class="nav">
  <a class="brand" href="index.html"><img src="assets/ecosafe-logo.png" alt="EcoSafe Bangladesh"></a>
  <nav class="navlinks">
    <a href="about.html">About Us</a><a href="services.html">Services</a><a href="projects.html">Projects</a><a href="join.html">Join Us</a><a href="contact.html">Contact Us</a>
  </nav>
  <button class="nav-toggle" aria-label="Open menu"><span></span><span></span></button>
</header>
<div class="mobile-menu"><div class="mobile-menu-inner"><a href="about.html">About Us</a><a href="services.html">Services</a><a href="projects.html">Projects</a><a href="join.html">Join Us</a><a href="contact.html">Contact Us</a></div></div>`;
document.body.insertAdjacentHTML('afterbegin',nav);
