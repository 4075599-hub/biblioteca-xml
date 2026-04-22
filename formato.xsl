<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <html lang="es">
            <head>
                <meta charset="UTF-8"/>
                <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                <title>Libreria - Sunset Edition</title>
                <style>
                    :root {
                        /* PALETA CÁLIDA (Sin rosa) */
                        --primary: #f59e0b;        /* Naranja Ámbar */
                        --primary-soft: #fff7ed;   /* Crema muy suave */
                        --accent: #06b6d4;         /* Cian equilibrado */
                        --sugar-orange: #fb923c;   /* Naranja vibrante para detalles */
                        --sugar-blue: #1e3a8a;     /* Azul marino para contraste de lectura */
                        
                        --side-bg: #ffffff;
                        --main-bg: #fafaf9;
                        --text-dark: #1c1917;      /* Gris piedra oscuro */
                        --text-light: #78716c;
                        --card-bg: rgba(255, 255, 255, 0.96);
                        --border: #e7e5e4;
                        --base-font-size: 16px;
                        --line-spacing: 1.6;
                    }

                    .dark-mode {
                        --primary: #fbbf24;
                        --primary-soft: rgba(251, 191, 36, 0.1);
                        --accent: #22d3ee;
                        --side-bg: #1c1917;
                        --main-bg: #0c0a09;
                        --text-dark: #f5f5f4;
                        --text-light: #a8a29e;
                        --card-bg: rgba(41, 37, 36, 0.92);
                        --border: #44403c;
                        --sugar-blue: #93c5fd;
                    }

                    .filter-sepia { filter: sepia(0.4) contrast(0.9) !important; }
                    .filter-contrast { filter: contrast(1.15) brightness(1.05) !important; }

                    * { box-sizing: border-box; margin: 0; padding: 0; transition: background 0.3s, color 0.3s, filter 0.3s; }
                    html { scroll-behavior: smooth; font-size: var(--base-font-size); }

                    body {
                        font-family: 'Segoe UI', system-ui, sans-serif;
                        display: grid;
                        grid-template-columns: 350px 1fr;
                        height: 100vh;
                        overflow: hidden;
                        background-color: var(--main-bg);
                        color: var(--text-dark);
                    }

                    #canvas-bg {
                        position: fixed;
                        top: 0; left: 0;
                        width: 100%; height: 100%;
                        z-index: 0;
                        pointer-events: none;
                    }

                    aside {
                        background: var(--side-bg);
                        padding: 2.5rem;
                        border-right: 1px solid var(--border);
                        z-index: 10;
                        position: relative;
                        overflow-y: auto;
                    }

                    .brand { font-size: 2.2rem; font-weight: 900; margin-bottom: 2rem; color: var(--text-dark); }
                    .brand span { color: var(--primary); }

                    .search-box {
                        background: var(--main-bg);
                        border: 2px solid var(--border);
                        padding: 14px;
                        border-radius: 12px;
                        color: var(--text-dark);
                        width: 100%;
                        margin-bottom: 2rem;
                        outline: none;
                    }
                    .search-box:focus { border-color: var(--primary); }

                    .link-item { 
                        color: var(--text-dark); text-decoration: none; font-weight: 600; 
                        display: block; padding: 12px; border-bottom: 1px solid var(--border);
                        border-radius: 8px; margin-bottom: 4px;
                    }
                    .link-item:hover { background: var(--primary-soft); color: var(--primary); }

                    main {
                        overflow-y: auto;
                        padding: 4rem;
                        position: relative;
                        z-index: 1;
                    }

                    .accessibility-menu {
                        position: fixed; top: 2rem; right: 2rem;
                        background: var(--card-bg);
                        padding: 20px; border-radius: 24px;
                        border: 1px solid var(--border);
                        box-shadow: 0 10px 25px rgba(0,0,0,0.05);
                        z-index: 100; backdrop-filter: blur(10px); width: 240px;
                    }

                    .menu-section { margin-bottom: 15px; padding-bottom: 10px; border-bottom: 1px solid var(--border); }
                    .menu-label { font-size: 0.7rem; font-weight: 800; text-transform: uppercase; color: var(--text-light); display: block; margin-bottom: 8px; }
                    
                    .btn-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; }
                    .acc-btn {
                        padding: 8px; border-radius: 8px; border: 1px solid var(--border);
                        background: var(--main-bg); color: var(--text-dark); cursor: pointer; font-size: 0.8rem; font-weight: 600;
                    }
                    .acc-btn:hover { border-color: var(--primary); background: var(--primary-soft); }

                    select, input[type="range"] { width: 100%; padding: 5px; border-radius: 5px; margin-top: 5px; }

                    .card-grid { display: flex; flex-direction: column; gap: 2.5rem; max-width: 800px; }
                    
                    .book-card {
                        background: var(--card-bg);
                        border-radius: 28px;
                        padding: 2.5rem;
                        border: 1px solid var(--border);
                        backdrop-filter: blur(8px);
                        position: relative;
                        margin-bottom: 1rem;
                        box-shadow: 0 4px 20px rgba(0,0,0,0.02);
                    }

                    .book-id-badge {
                        position: absolute; top: 2.5rem; right: 2.5rem;
                        background: var(--primary);
                        color: #fff;
                        padding: 4px 14px;
                        border-radius: 10px;
                        font-family: monospace;
                        font-size: 0.85rem;
                        font-weight: 800;
                    }

                    .author-text { color: var(--sugar-orange); font-weight: 700; margin-bottom: 1.5rem; display: block; text-transform: uppercase; }
                    .stats { display: flex; gap: 2rem; background: var(--primary-soft); padding: 1rem 1.5rem; border-radius: 15px; margin-bottom: 1.5rem; font-size: 0.95rem; color: var(--sugar-blue); font-weight: 600; }
                    .stats b { color: var(--text-dark); }
                    
                    .synopsis-box { line-height: var(--line-spacing); border-left: 4px solid var(--accent); padding-left: 20px; font-size: 1.05rem; color: var(--text-dark); }
                </style>
            </head>
            <body id="body-app">
                <canvas id="canvas-bg"></canvas>

                <aside>
                    <div class="brand">Libreria<span>.</span></div>
                    <input type="text" id="search" class="search-box" placeholder="Buscar lectura..." onkeyup="filterBooks()"/>
                    <div class="nav-container">
                        <xsl:for-each select="biblioteca/libro">
                            <a href="#{@id}" class="link-item"><xsl:value-of select="titulo"/></a>
                        </xsl:for-each>
                    </div>
                </aside>

                <main>
                    <div class="accessibility-menu">
                        <div class="menu-section">
                            <span class="menu-label">Visualización</span>
                            <div class="btn-grid">
                                <button class="acc-btn" onclick="toggleMode()">🌙 Modo</button>
                                <button class="acc-btn" onclick="applyFilter('sepia')">📜 Sepia</button>
                                <button class="acc-btn" onclick="applyFilter('contrast')">👁️ Pop</button>
                                <button class="acc-btn" onclick="applyFilter('reset')">🔄 Reset</button>
                            </div>
                        </div>
                        <div class="menu-section">
                            <span class="menu-label">Texto</span>
                            <div class="btn-grid">
                                <button class="acc-btn" onclick="adjustFont(2)">A+</button>
                                <button class="acc-btn" onclick="adjustFont(-2)">A-</button>
                                <button class="acc-btn" onclick="adjustSpacing(0.2)">↕️+</button>
                                <button class="acc-btn" onclick="adjustSpacing(-0.2)">↕️-</button>
                            </div>
                        </div>
                        <div class="menu-section">
                            <span class="menu-label">Ambiente</span>
                            <select id="bg-style" onchange="initParticles()">
                                <option value="constellation">Constelación</option>
                                <option value="dust">Polvo Estelar</option>
                                <option value="orbs">Orbes Suaves</option>
                            </select>
                            <input type="color" id="bg-color" value="#f59e0b" style="margin-top:10px; height:30px; border:none; cursor:pointer; width:100%; border-radius:5px;"/>
                            <input type="range" id="bg-density" min="20" max="200" value="150" onchange="initParticles()"/>
                        </div>
                    </div>

                    <div class="card-grid">
                        <xsl:for-each select="biblioteca/libro">
                            <article class="book-card" id="{@id}">
                                <div class="book-id-badge">ID <xsl:value-of select="@id"/></div>
                                <h2><xsl:value-of select="titulo"/></h2>
                                <span class="author-text">Autor: <xsl:value-of select="autor"/></span>
                                <div class="stats">
                                    <span><b>Año:</b> <xsl:value-of select="anio"/></span>
                                    <span><b>Págs:</b> <xsl:value-of select="paginas"/></span>
                                    <span><b>Cat:</b> <xsl:value-of select="@categoria"/></span>
                                </div>
                                <p class="synopsis-box"><xsl:value-of select="sinopsis"/><xsl:value-of select="synopsis"/></p>
                            </article>
                        </xsl:for-each>
                    </div>
                </main>

                <script>
                    // <![CDATA[
                    let fSize = 16;
                    let spacing = 1.6;
                    let mouse = { x: null, y: null };

                    window.addEventListener('mousemove', (e) => {
                        mouse.x = e.clientX;
                        mouse.y = e.clientY;
                    });

                    function toggleMode() { document.body.classList.toggle('dark-mode'); }
                    
                    function applyFilter(f) {
                        const b = document.getElementById('body-app');
                        if(f === 'reset') {
                            b.classList.remove('filter-sepia', 'filter-contrast');
                            fSize = 16;
                            spacing = 1.6;
                            document.documentElement.style.setProperty('--base-font-size', '16px');
                            document.documentElement.style.setProperty('--line-spacing', 1.6);
                            return;
                        }
                        b.classList.remove('filter-sepia', 'filter-contrast');
                        b.classList.add('filter-' + f);
                    }

                    function adjustFont(n) {
                        fSize += n;
                        document.documentElement.style.setProperty('--base-font-size', fSize + 'px');
                    }

                    function adjustSpacing(n) {
                        spacing += n;
                        document.documentElement.style.setProperty('--line-spacing', spacing);
                    }

                    function filterBooks() {
                        let query = document.getElementById('search').value.toLowerCase();
                        let cards = document.getElementsByClassName('book-card');
                        for(let c of cards) {
                            c.style.display = c.innerText.toLowerCase().includes(query) ? "" : "none";
                        }
                    }

                    const canvas = document.getElementById('canvas-bg');
                    const ctx = canvas.getContext('2d');
                    let particles = [];

                    function resize() {
                        canvas.width = window.innerWidth;
                        canvas.height = window.innerHeight;
                    }
                    window.addEventListener('resize', resize);
                    resize();

                    class Particle {
                        constructor() { this.reset(); }
                        reset() {
                            this.x = Math.random() * canvas.width;
                            this.y = Math.random() * canvas.height;
                            this.vx = (Math.random() - 0.5) * 0.5;
                            this.vy = (Math.random() - 0.5) * 0.5;
                            this.radius = Math.random() * 2 + 1;
                        }
                        update() {
                            if (mouse.x !== null) {
                                let dx = mouse.x - this.x;
                                let dy = mouse.y - this.y;
                                let dist = Math.sqrt(dx*dx + dy*dy);
                                if (dist < 150) {
                                    let force = (150 - dist) / 150;
                                    this.x -= dx * force * 0.03;
                                    this.y -= dy * force * 0.03;
                                }
                            }
                            this.x += this.vx; this.y += this.vy;
                            if(this.x < 0 || this.x > canvas.width) this.vx *= -1;
                            if(this.y < 0 || this.y > canvas.height) this.vy *= -1;
                        }
                    }

                    function initParticles() {
                        particles = [];
                        let density = document.getElementById('bg-density').value;
                        for(let i=0; i < density; i++) particles.push(new Particle());
                    }

                    function animate() {
                        ctx.clearRect(0,0, canvas.width, canvas.height);
                        let style = document.getElementById('bg-style').value;
                        let color = document.getElementById('bg-color').value;

                        particles.forEach((p, i) => {
                            p.update();
                            ctx.beginPath();
                            ctx.arc(p.x, p.y, (style === 'orbs' ? p.radius * 5 : p.radius), 0, Math.PI*2);
                            ctx.fillStyle = color;
                            ctx.globalAlpha = (style === 'orbs' ? 0.1 : 0.4);
                            ctx.fill();

                            if(style === 'constellation') {
                                for(let j=i; j < particles.length; j++) {
                                    let dx = p.x - particles[j].x;
                                    let dy = p.y - particles[j].y;
                                    let dist = Math.sqrt(dx*dx + dy*dy);
                                    if(dist < 150) {
                                        ctx.strokeStyle = color;
                                        ctx.globalAlpha = 0.2 * (1 - (dist/150));
                                        ctx.lineWidth = 0.5;
                                        ctx.beginPath();
                                        ctx.moveTo(p.x, p.y);
                                        ctx.lineTo(particles[j].x, particles[j].y);
                                        ctx.stroke();
                                    }
                                }
                            }
                        });
                        requestAnimationFrame(animate);
                    }

                    initParticles();
                    animate();
                    // ]]>
                </script>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>