import { useEffect, useMemo, useState } from 'react'

const money = new Intl.NumberFormat('fr-FR')

const toneCopy = {
  formal: {
    eyebrow: 'La gestion commerciale, réinventée',
    title: <>Des documents impeccables.<br /><em>En quelques secondes.</em></>,
    lead: 'InvoiceAI transforme vos informations commerciales en devis et factures clairs, fiables et prêts à être envoyés.',
    primary: 'Accéder à l’application',
    secondary: 'Découvrir les services',
  },
  simple: {
    eyebrow: 'Fini les factures qui traînent',
    title: <>Tu vends. On met tout<br /><em>au propre.</em></>,
    lead: 'Décris juste ce que tu as vendu. InvoiceAI prépare le devis ou la facture pendant que tu passes à la suite.',
    primary: 'Créer mon document',
    secondary: 'Voir comment ça marche',
  },
}

function Logo({ inverse = false }) {
  return (
    <a className={`logo ${inverse ? 'logo--inverse' : ''}`} href="#accueil" aria-label="InvoiceAI, retour à l’accueil">
      <span className="logo__mark" aria-hidden="true">
        <span className="logo__fold" />
        <span className="logo__spark">✦</span>
      </span>
      <span>Invoice<span>AI</span></span>
    </a>
  )
}

function ArrowIcon() {
  return <svg viewBox="0 0 20 20" aria-hidden="true"><path d="M4 10h11M11 5l5 5-5 5" /></svg>
}

function MenuIcon({ open }) {
  return <svg viewBox="0 0 24 24" aria-hidden="true">{open ? <><path d="M6 6l12 12M18 6 6 18" /></> : <><path d="M4 7h16M4 12h16M4 17h16" /></>}</svg>
}

function Landing({ tone, setTone }) {
  const [menuOpen, setMenuOpen] = useState(false)
  const copy = toneCopy[tone]

  const openApp = () => {
    window.location.hash = '/app/devis'
    window.scrollTo(0, 0)
  }

  return (
    <div className="landing" data-tone={tone}>
      <header className="site-header">
        <div className="container site-header__inner">
          <Logo />
          <button className="mobile-menu" onClick={() => setMenuOpen(!menuOpen)} aria-label="Ouvrir le menu" aria-expanded={menuOpen}>
            <MenuIcon open={menuOpen} />
          </button>
          <nav className={menuOpen ? 'site-nav is-open' : 'site-nav'} aria-label="Navigation principale">
            <a href="#accueil" onClick={() => setMenuOpen(false)}>Accueil</a>
            <a href="#apropos" onClick={() => setMenuOpen(false)}>À propos</a>
            <a href="#services" onClick={() => setMenuOpen(false)}>Services</a>
            <div className="tone-switch" aria-label="Choisir le ton de présentation">
              <button className={tone === 'formal' ? 'active' : ''} onClick={() => setTone('formal')}>Formel</button>
              <button className={tone === 'simple' ? 'active' : ''} onClick={() => setTone('simple')}>Simple</button>
            </div>
            <button className="nav-cta" onClick={openApp}>Faire un devis / facture <ArrowIcon /></button>
          </nav>
        </div>
      </header>

      <main>
        <section className="hero" id="accueil">
          <div className="container hero__grid">
            <div className="hero__copy">
              <div className="eyebrow"><span>✦</span>{copy.eyebrow}</div>
              <h1>{copy.title}</h1>
              <p className="hero__lead">{copy.lead}</p>
              <div className="hero__actions">
                <button className="button button--primary" onClick={openApp}>{copy.primary}<ArrowIcon /></button>
                <a className="button button--ghost" href="#services">{copy.secondary}</a>
              </div>
              <div className="hero__proof">
                <div className="avatars" aria-hidden="true"><span>AN</span><span>MD</span><span>FB</span></div>
                <p><strong>+1 200 entrepreneurs</strong><br />gagnent du temps chaque semaine</p>
              </div>
            </div>
            <HeroVisual />
          </div>
          <div className="hero__ticker" aria-hidden="true">
            <div><span>DEVIS EN 2 MINUTES</span><b>✦</b><span>CALCULS AUTOMATIQUES</span><b>✦</b><span>DOCUMENTS PROFESSIONNELS</span><b>✦</b><span>PAIEMENTS MIEUX SUIVIS</span></div>
          </div>
        </section>

        <section className="about section" id="apropos">
          <div className="container about__grid">
            <div className="section-intro">
              <span className="section-number">01 / À propos</span>
              <h2>Votre activité mérite mieux qu’un tableau compliqué.</h2>
            </div>
            <div className="about__content">
              <p className="about__lead">InvoiceAI est pensé pour celles et ceux qui font tourner leur entreprise au quotidien — commerçants, artisans, indépendants et petites équipes.</p>
              <p>Notre mission est simple : rendre la gestion commerciale aussi naturelle qu’une conversation. Vous saisissez l’essentiel, nous structurons le reste.</p>
              <div className="about__stats">
                <div><strong>2 min</strong><span>pour créer un document</span></div>
                <div><strong>0 erreur</strong><span>dans les calculs</span></div>
                <div><strong>24/7</strong><span>accessible partout</span></div>
              </div>
            </div>
          </div>
        </section>

        <section className="services section" id="services">
          <div className="container">
            <div className="services__heading">
              <div>
                <span className="section-number section-number--light">02 / Services</span>
                <h2>Tout ce qu’il faut.<br /><em>Rien de superflu.</em></h2>
              </div>
              <p>Une expérience fluide du premier devis jusqu’au paiement final.</p>
            </div>
            <div className="service-grid">
              <article className="service-card service-card--featured">
                <span className="service-card__index">01</span>
                <div className="service-icon">✦</div>
                <h3>Saisie intelligente</h3>
                <p>Décrivez votre vente avec vos mots. L’assistant reconnaît le client, les articles, les quantités et les prix.</p>
                <span className="service-link">Analyser une vente <ArrowIcon /></span>
              </article>
              <article className="service-card">
                <span className="service-card__index">02</span>
                <div className="service-icon service-icon--paper">D</div>
                <h3>Création de devis</h3>
                <p>Présentez une offre nette, modifiable et prête à être validée par votre client.</p>
                <button className="service-link" onClick={() => { window.location.hash = '/app/devis'; window.scrollTo(0, 0) }}>Créer un devis <ArrowIcon /></button>
              </article>
              <article className="service-card">
                <span className="service-card__index">03</span>
                <div className="service-icon service-icon--paper">F</div>
                <h3>Génération de facture</h3>
                <p>Calculez automatiquement vos totaux et obtenez une facture au rendu professionnel.</p>
                <button className="service-link" onClick={() => { window.location.hash = '/app/facture'; window.scrollTo(0, 0) }}>Générer une facture <ArrowIcon /></button>
              </article>
            </div>
          </div>
        </section>

        <section className="process section">
          <div className="container process__grid">
            <div className="section-intro">
              <span className="section-number">03 / Comment ça marche</span>
              <h2>De l’idée au document en trois gestes.</h2>
              <button className="text-button" onClick={openApp}>Essayer maintenant <ArrowIcon /></button>
            </div>
            <ol className="steps-list">
              <li><span>01</span><div><h3>Choisissez votre document</h3><p>Un devis pour proposer, une facture pour encaisser.</p></div></li>
              <li><span>02</span><div><h3>Ajoutez les informations</h3><p>Client, produits ou services, prix et conditions.</p></div></li>
              <li><span>03</span><div><h3>Vérifiez et partagez</h3><p>Votre document est propre, calculé et prêt à partir.</p></div></li>
            </ol>
          </div>
        </section>

        <section className="final-cta">
          <div className="container final-cta__inner">
            <span className="final-cta__spark">✦</span>
            <p>Votre prochaine facture ne devrait pas vous prendre la soirée.</p>
            <h2>Prêt à facturer<br /><em>plus simplement ?</em></h2>
            <button className="button button--cream" onClick={openApp}>Ouvrir InvoiceAI <ArrowIcon /></button>
          </div>
        </section>
      </main>

      <footer className="footer">
        <div className="container footer__top">
          <Logo inverse />
          <p>Devis et factures intelligents<br />pour les entrepreneurs ambitieux.</p>
          <div className="footer__links"><a href="#accueil">Accueil</a><a href="#apropos">À propos</a><a href="#services">Services</a></div>
        </div>
        <div className="container footer__bottom"><span>© 2026 InvoiceAI</span><span>Conçu avec soin à Dakar</span></div>
      </footer>
    </div>
  )
}

function HeroVisual() {
  return (
    <div className="hero-visual" aria-label="Aperçu d’une facture générée par InvoiceAI">
      <div className="hero-visual__shape" />
      <div className="speech-card">
        <span className="speech-card__avatar">AN</span>
        <p>3 sacs de riz à Aminata,<br />15 000 F chacun + livraison</p>
        <span className="speech-card__sent">envoyé ✓</span>
      </div>
      <div className="invoice-card">
        <div className="invoice-card__top"><Logo /><span>FACTURE<br /><b>#024</b></span></div>
        <div className="invoice-card__client"><small>FACTURÉ À</small><strong>Aminata Diallo</strong><span>Marché Diallo · Dakar</span></div>
        <div className="invoice-card__lines">
          <div><span>3 × Sacs de riz</span><b>45 000 F</b></div>
          <div><span>Livraison</span><b>5 000 F</b></div>
        </div>
        <div className="invoice-card__total"><span>Total</span><strong>50 000 <small>FCFA</small></strong></div>
        <div className="invoice-card__status"><span>✓</span> Prête à envoyer</div>
      </div>
      <div className="time-pill"><span>↗</span><div><strong>2 min</strong><small>au lieu de 20</small></div></div>
    </div>
  )
}

const blankItem = () => ({ id: crypto.randomUUID(), description: '', quantity: 1, price: 0 })

function Workspace() {
  const path = window.location.hash.includes('facture') ? 'facture' : 'devis'
  const [active, setActive] = useState(path)
  const [mobileNav, setMobileNav] = useState(false)
  const [toast, setToast] = useState('')

  const changeActive = (value) => {
    setActive(value)
    setMobileNav(false)
    window.location.hash = `/app/${value}`
    window.scrollTo(0, 0)
  }

  const notify = (message) => {
    setToast(message)
    window.setTimeout(() => setToast(''), 2600)
  }

  return (
    <div className="workspace">
      <aside className={mobileNav ? 'workspace-nav is-open' : 'workspace-nav'}>
        <div className="workspace-nav__top">
          <Logo inverse />
          <button className="workspace-nav__close" onClick={() => setMobileNav(false)} aria-label="Fermer le menu">×</button>
        </div>
        <p className="workspace-nav__label">ESPACE DE TRAVAIL</p>
        <nav aria-label="Menu de l’application">
          <button className={active === 'devis' ? 'active' : ''} onClick={() => changeActive('devis')}><span className="nav-icon">D</span><span><strong>Création de devis</strong><small>Préparer une offre</small></span></button>
          <button className={active === 'facture' ? 'active' : ''} onClick={() => changeActive('facture')}><span className="nav-icon">F</span><span><strong>Génération facture</strong><small>Créer et finaliser</small></span></button>
        </nav>
        <div className="workspace-nav__help"><span>✦</span><strong>Besoin d’un coup de main ?</strong><p>Décrivez simplement votre vente dans le générateur.</p></div>
        <div className="workspace-profile"><span>AN</span><div><strong>Awa Ndiaye</strong><small>Ndiaye Créations</small></div><b>•••</b></div>
      </aside>
      <main className="workspace-main">
        <header className="workspace-header">
          <button className="workspace-menu-button" onClick={() => setMobileNav(true)} aria-label="Ouvrir le menu"><MenuIcon /></button>
          <div><span className="status-dot" /> Toutes les modifications sont enregistrées</div>
          <button onClick={() => { window.location.hash = ''; window.scrollTo(0, 0) }}>← Retour au site</button>
        </header>
        {active === 'devis' ? <DocumentBuilder key="devis" type="devis" notify={notify} /> : <DocumentBuilder key="facture" type="facture" notify={notify} />}
      </main>
      {toast && <div className="toast" role="status"><span>✓</span>{toast}</div>}
    </div>
  )
}

function DocumentBuilder({ type, notify }) {
  const isInvoice = type === 'facture'
  const [client, setClient] = useState(isInvoice ? 'Aminata Diallo' : '')
  const [title, setTitle] = useState(isInvoice ? 'Vente de marchandises' : 'Création de site vitrine')
  const [tax, setTax] = useState(18)
  const [items, setItems] = useState(isInvoice ? [
    { id: 'rice', description: 'Sacs de riz', quantity: 3, price: 15000 },
    { id: 'delivery', description: 'Livraison', quantity: 1, price: 5000 },
  ] : [
    { id: 'design', description: 'Conception et design', quantity: 1, price: 180000 },
    { id: 'dev', description: 'Développement responsive', quantity: 1, price: 320000 },
  ])
  const [naturalText, setNaturalText] = useState('J’ai livré 3 sacs de riz à Aminata Diallo, 15 000 FCFA chacun, plus transport 5 000 FCFA.')
  const [analyzing, setAnalyzing] = useState(false)

  const subtotal = useMemo(() => items.reduce((total, item) => total + Number(item.quantity || 0) * Number(item.price || 0), 0), [items])
  const taxTotal = Math.round(subtotal * tax / 100)
  const total = subtotal + taxTotal
  const number = `${isInvoice ? 'FAC' : 'DEV'}-2026-${isInvoice ? '024' : '008'}`

  const updateItem = (id, key, value) => setItems(items.map(item => item.id === id ? { ...item, [key]: value } : item))
  const removeItem = (id) => setItems(items.filter(item => item.id !== id))
  const addItem = () => setItems([...items, blankItem()])

  const analyze = () => {
    if (!naturalText.trim()) return
    setAnalyzing(true)
    window.setTimeout(() => {
      setClient('Aminata Diallo')
      setTitle('Vente de marchandises')
      setItems([
        { id: 'rice', description: 'Sacs de riz', quantity: 3, price: 15000 },
        { id: 'delivery', description: 'Transport', quantity: 1, price: 5000 },
      ])
      setAnalyzing(false)
      notify('Informations détectées et ajoutées à la facture.')
    }, 700)
  }

  return (
    <div className="builder">
      <div className="builder__heading">
        <div><span className="builder__eyebrow">{isInvoice ? 'FACTURATION INTELLIGENTE' : 'NOUVEAU DOCUMENT'}</span><h1>{isInvoice ? 'Générer une facture' : 'Créer un devis'}</h1><p>{isInvoice ? 'Partez d’une phrase ou ajustez les informations manuellement.' : 'Composez une proposition claire que votre client comprendra immédiatement.'}</p></div>
        <span className="draft-badge"><i /> Brouillon</span>
      </div>

      {isInvoice && <section className="ai-box">
        <div className="ai-box__heading"><span>✦</span><div><strong>Décrivez votre vente</strong><small>L’assistant transforme votre texte en facture structurée.</small></div></div>
        <textarea value={naturalText} onChange={event => setNaturalText(event.target.value)} aria-label="Description de la vente" />
        <div className="ai-box__footer"><span>Exemple : nom du client, articles, quantités et prix</span><button onClick={analyze} disabled={analyzing}>{analyzing ? 'Analyse en cours…' : '✦ Analyser le texte'}</button></div>
      </section>}

      <div className="builder__grid">
        <div className="editor-panel">
          <section className="form-section">
            <div className="form-section__title"><span>01</span><div><h2>Informations générales</h2><p>Les détails principaux du document.</p></div></div>
            <div className="form-grid">
              <label>Client<input value={client} onChange={event => setClient(event.target.value)} placeholder="Nom ou entreprise du client" /></label>
              <label>{isInvoice ? 'Objet de la facture' : 'Objet du devis'}<input value={title} onChange={event => setTitle(event.target.value)} /></label>
              <label>Date d’émission<input type="date" defaultValue="2026-08-09" /></label>
              <label>{isInvoice ? 'Échéance' : 'Validité'}<select defaultValue="15"><option value="7">7 jours</option><option value="15">15 jours</option><option value="30">30 jours</option></select></label>
            </div>
          </section>

          <section className="form-section">
            <div className="form-section__title"><span>02</span><div><h2>Prestations et articles</h2><p>Ajoutez ce que vous vendez.</p></div></div>
            <div className="items-table">
              <div className="items-table__head"><span>Description</span><span>Qté</span><span>Prix unitaire</span><span>Total</span><span /></div>
              {items.map(item => <div className="items-table__row" key={item.id}>
                <input aria-label="Description" value={item.description} onChange={event => updateItem(item.id, 'description', event.target.value)} placeholder="Description" />
                <input aria-label="Quantité" type="number" min="0" value={item.quantity} onChange={event => updateItem(item.id, 'quantity', event.target.value)} />
                <div className="money-input"><input aria-label="Prix unitaire" type="number" min="0" value={item.price} onChange={event => updateItem(item.id, 'price', event.target.value)} /><span>F</span></div>
                <strong>{money.format(Number(item.quantity || 0) * Number(item.price || 0))} F</strong>
                <button onClick={() => removeItem(item.id)} aria-label="Supprimer la ligne">×</button>
              </div>)}
              <button className="add-line" onClick={addItem}>＋ Ajouter une ligne</button>
            </div>
          </section>

          <section className="form-section form-section--compact">
            <div className="form-section__title"><span>03</span><div><h2>Taxes et conditions</h2><p>Finalisez les paramètres.</p></div></div>
            <div className="form-grid">
              <label>TVA<select value={tax} onChange={event => setTax(Number(event.target.value))}><option value="0">Sans TVA</option><option value="18">18 %</option></select></label>
              <label>Conditions de paiement<select defaultValue="cash"><option value="cash">Paiement à réception</option><option value="15">Sous 15 jours</option><option value="30">Sous 30 jours</option></select></label>
            </div>
          </section>
        </div>

        <aside className="preview-panel">
          <div className="preview-panel__bar"><span>Aperçu en direct</span><button onClick={() => window.print()} aria-label="Imprimer le document">↗</button></div>
          <div className="document-preview">
            <div className="document-preview__header"><Logo /><div><span>{isInvoice ? 'FACTURE' : 'DEVIS'}</span><strong>{number}</strong></div></div>
            <div className="document-preview__meta"><div><small>ÉMETTEUR</small><strong>Ndiaye Créations</strong><span>Dakar, Sénégal</span><span>+221 77 000 00 00</span></div><div><small>{isInvoice ? 'FACTURÉ À' : 'DESTINATAIRE'}</small><strong>{client || 'Client à renseigner'}</strong><span>{title}</span></div></div>
            <div className="document-preview__dates"><span><small>Date</small>09 août 2026</span><span><small>{isInvoice ? 'Échéance' : 'Valide jusqu’au'}</small>24 août 2026</span></div>
            <div className="document-preview__table">
              <div><span>DÉSIGNATION</span><span>QTÉ</span><span>MONTANT</span></div>
              {items.filter(item => item.description).map(item => <div key={item.id}><span>{item.description}</span><span>{item.quantity}</span><strong>{money.format(Number(item.quantity || 0) * Number(item.price || 0))} F</strong></div>)}
            </div>
            <div className="document-preview__totals"><p><span>Sous-total</span><strong>{money.format(subtotal)} F</strong></p><p><span>TVA ({tax} %)</span><strong>{money.format(taxTotal)} F</strong></p><p className="grand-total"><span>Total</span><strong>{money.format(total)} FCFA</strong></p></div>
            <p className="document-preview__note">Merci pour votre confiance. Ce document a été préparé avec InvoiceAI.</p>
          </div>
          <div className="preview-actions"><button className="button button--outline" onClick={() => window.print()}>Aperçu PDF</button><button className="button button--primary" onClick={() => notify(`${isInvoice ? 'Facture' : 'Devis'} ${number} créé avec succès.`)}>{isInvoice ? 'Générer la facture' : 'Enregistrer le devis'} <ArrowIcon /></button></div>
        </aside>
      </div>
    </div>
  )
}

export default function App() {
  const [tone, setTone] = useState('formal')
  const [route, setRoute] = useState(window.location.hash)

  useEffect(() => {
    const onHashChange = () => setRoute(window.location.hash)
    window.addEventListener('hashchange', onHashChange)
    return () => window.removeEventListener('hashchange', onHashChange)
  }, [])

  return route.startsWith('#/app') ? <Workspace /> : <Landing tone={tone} setTone={setTone} />
}
