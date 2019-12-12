-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le :  jeu. 12 déc. 2019 à 15:29
-- Version du serveur :  10.4.8-MariaDB
-- Version de PHP :  7.3.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `base_test`
--

-- --------------------------------------------------------

--
-- Structure de la table `canonic`
--

CREATE TABLE `canonic` (
  `Gene_Symbol` varchar(20) NOT NULL,
  `Gene_Name` varchar(200) NOT NULL,
  `C_Pathway` varchar(1000) NOT NULL,
  `C_Loc` varchar(1000) NOT NULL,
  `num_can` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `canonic`
--

INSERT INTO `canonic` (`Gene_Symbol`, `Gene_Name`, `C_Pathway`, `C_Loc`, `num_can`) VALUES
('HK2', 'Hexokinase 2', 'Convert phosphorylate glucose to glucose 6-phosphate', 'Cytosol', 1),
('GPI', 'Phosphoglucose isomerase', 'Interconvert G6P to fructose 6-phosphate (F6P)', 'Cytosol', 2),
('PFKM', 'Phosphofructokinase', 'Phosphorylate F6P to fructose 1,6-biphosphate', 'Cytosol', 3),
('PFKFB3', '6-phosphofructose-2-kinase/fructose-2,6-biphosphatase 3', 'Interconvert F6P to fructose 2,6-biphosphate (F2,6BP)', 'Cytosol', 4),
('FBP1', 'Fructose 1,6-biphosphate', 'Hydrolyze F1,6BP to F6P', 'Cytosol', 5),
('ALDOA', 'Aldolase A', 'Split F1,6BP to dihydroxyacetone phosphate (DHAP) and glyceraldehyde', 'Cytosol', 6),
('GAPDH', 'Glyceraldehyde 3-phosphate dehydrogenase', 'Interconvert G3P to 1,3-biphosphoglycerate', 'Cytosol', 7),
('PGK1', 'Phosphoglycerate kinase', 'Interconvert 1,3BPG to 3-phosphoglycerate', 'Cytosol', 8),
('ENO1', 'Enolase 1', 'Interconvert 2-phosphoglycerate to phosphoenolpyruvate (PEP)', 'Cytosol', 9),
('PKM', 'Pyruvate kinase 2', 'Transfer a phosphate group from PEP to ADP to yield pyruvate and ATP', 'Cytosol', 10),
('LDHA', 'Lactate dehydrogenase A', 'Interconvert lactate to pyruvate', 'Cytosol', 11),
('ACO2', 'Aconitase', 'Interconvert citrate to isocitrate in the tricarboxylic acid (TCA) cycle', 'Mitocondria', 12),
('SUCLG1', 'Succinyl-CoA synthetase', 'Interconvert succinyl-CoA to succinate in the TCA cycle', 'Mitochondria', 13),
('FH', 'Fumarase ', 'Interconvert fumarate to malate in the TCA cycle', 'Mitochondria', 14),
('MDH1', 'Malate dehydrogenase', 'Interconvert malate to oxaloacetate in the TCA cycle', 'Cytosol', 15),
('MDH2', 'Malate dehydrogenase', 'Interconvert malate to oxaloacetate in the TCA cycle', 'Mitochondria', 16),
('PDC', 'Pyruvate dehydrogenase complex', 'Convert pyruvate to acetyl-CoA', 'Mitochondria', 17),
('ACLY', 'ATP-citrate lyase', 'Convert citrate to oxaloacetate and acetyl-CoA', 'Mitochondria', 18),
('ACSS2', 'Acetyl-CoA synthetase short-chain family member 2', 'Catalyze acetate to acetyl-CoA', 'Cytosol', 19),
('MAT2A', 'methionine adenosyltransferase IIalpha', 'Produce S-adenosylmethionine (SAM) from methionine', 'Cytosol', 20),
('SHMT-1', 'Serine hydroxymethyltransferase', 'Interconvert L-serine to glycine and tetrahydrofolate 5,10-methylenetetrahydrofolate', 'Cytosol', 21);

-- --------------------------------------------------------

--
-- Structure de la table `ncanonic`
--

CREATE TABLE `ncanonic` (
  `Gene_Symbol` varchar(20) NOT NULL,
  `NC_Pathway` varchar(1000) NOT NULL,
  `NC_Loc` varchar(1000) NOT NULL,
  `Ref` varchar(1000) NOT NULL,
  `num_ncan` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `ncanonic`
--

INSERT INTO `ncanonic` (`Gene_Symbol`, `NC_Pathway`, `NC_Loc`, `Ref`, `num_ncan`) VALUES
('HK2', 'Repress the expression of genes involved in glucose repression', 'Cytosol', 'The glucoseregulated nuclear localization of hexokinase 2 in Saccharomyces cerevisiae is Mig1-dependent -- Mitochondrial localization of TIGAR under hypoxia stimulates HK2 and lowers ROS and cell death -- Hexokinase II detachment from mitochondria triggers apoptosis through the permeability transition pore independent of voltage-dependent anion channels -- Inhibition of early apoptotic events by Akt/PKB is dependent on the first committed step of glycolysis and mitochondrial hexokinase -- Hexokinase-mitochondria interaction mediated by Akt is required to inhibit apoptosis in the presence or absence of Bax and Bak -- Mitochondrial binding of hexokinase II inhibits Bax-induced cytochrome c release and apoptosis', 1),
('HK2', 'Protect cells from apotosis by regulating the mitochondrial permeability transition pore and by limiting the production of reactive oxygen species', 'Mitochondria', 'The glucoseregulated nuclear localization of hexokinase 2 in Saccharomyces cerevisiae is Mig1-dependent -- Mitochondrial localization of TIGAR under hypoxia stimulates HK2 and lowers ROS and cell death -- Hexokinase II detachment from mitochondria triggers apoptosis through the permeability transition pore independent of voltage-dependent anion channels -- Inhibition of early apoptotic events by Akt/PKB is dependent on the first committed step of glycolysis and mitochondrial hexokinase -- Hexokinase-mitochondria interaction mediated by Akt is required to inhibit apoptosis in the presence or absence of Bax and Bak -- Mitochondrial binding of hexokinase II inhibits Bax-induced cytochrome c release and apoptosis', 2),
('GPI', 'Act as an autocrine factor extracellulary to elicit cell migration and proliferation', 'Extracellular localization', 'Phosphoglucose isomerase/autocrine motility factor mediates epithelial-mesenchymal transition regulated by miR-200 in breast cancer cells -- Autocrine motility factor/phosphoglucose isomerase regulates ER stress and cell death through control of ER calcium release. -- Regulation of phosphoglucose isomerase/autocrine motility factor expression by hypoxia -- The crystal structure of a multifunctional protein: phosphoglucose isomerase/autocrine motility factor/neuroleukin -- Tumor cell autocrine motility factor is the neuroleukin/phosphohexose isomerase polypeptide', 3),
('PFKM', 'Bind to transcription factor TEAD and stabilize its interaction with YAP/TAZ, and promote gene expression', 'Nucleus', 'Aerobic glycolysis tunes YAP/TAZ transcriptional activity', 4),
('PFKFB3', 'Promote cell cycle progression by upregulating cell cycle protein expression and downregulating cell cycle inhibitor p27', 'Nucleus', '6-Phosphofructo-2-kinase (PFKFB3) promotes cell cycle progression and suppresses apoptosis via Cdk1-mediated phosphorylation of p27 -- Nuclear targeting of 6-phosphofructo-2-kinase (PFKFB3) increases proliferation via cyclin-dependent kinases', 5),
('FBP1', 'Bind to hypoxia-inducible factors (HIFs) and inhibit their transcriptional activation of glycolytic gene expression', 'Nucleus', 'Fructose-1,6-bisphosphatase opposes renal carcinoma progression', 6),
('ALDOA', 'Participate in cytokinesis through its interaction with F-actin and Wiskott-Aldrich syndrome protein (WASP) family protein', 'Cytoskeleton', 'Characterization of an aldolase-binding site in the Wiskott-Aldrich syndrome protein -- Phosphoinositide 3-kinase regulates glycolysis through mobilization of aldolase from the actin cytoskeleton -- Aldolase mediates the association of F-actin with the insulin-responsive glucose transporter GLUT4 -- Targeting of several glycolytic enzymes using RNA interference reveals aldolase affects cancer cell proliferation through a non-glycolytic mechanism', 7),
('GADPH', 'Bind to colony-stimulating factor-1 (CSF-1) mRNA and stabilize its transcripts', 'Nucleus', 'Characterization of an aldolase-binding site in the Wiskott-Aldrich syndrome protein -- Phosphoinositide 3-kinase regulates glycolysis through mobilization of aldolase from the actin cytoskeleton -- Aldolase mediates the association of F-actin with the insulin-responsive glucose transporter GLUT4 -- Targeting of several glycolytic enzymes using RNA interference reveals aldolase affects cancer cell proliferation through a non-glycolytic mechanism', 8),
('GADPH', 'Function as a key component in the OCA-S complex, mediate its activation of H2B during S phase and promote cell cycle progression', 'Nucleus', 'Characterization of an aldolase-binding site in the Wiskott-Aldrich syndrome protein -- Phosphoinositide 3-kinase regulates glycolysis through mobilization of aldolase from the actin cytoskeleton -- Aldolase mediates the association of F-actin with the insulin-responsive glucose transporter GLUT4 -- Targeting of several glycolytic enzymes using RNA interference reveals aldolase affects cancer cell proliferation through a non-glycolytic mechanism', 9),
('GADPH', 'Protects telomeres against rapid shortening', 'Nucleus', 'Characterization of an aldolase-binding site in the Wiskott-Aldrich syndrome protein -- Phosphoinositide 3-kinase regulates glycolysis through mobilization of aldolase from the actin cytoskeleton -- Aldolase mediates the association of F-actin with the insulin-responsive glucose transporter GLUT4 -- Targeting of several glycolytic enzymes using RNA interference reveals aldolase affects cancer cell proliferation through a non-glycolytic mechanism', 10),
('GADPH', 'Increases DNA synthesis during S phase vie direct binding to single-stranded DNA (ssDNA) and stimulating the DNA-polymerase-alpha-primase complex', 'Nucleus', 'Characterization of an aldolase-binding site in the Wiskott-Aldrich syndrome protein -- Phosphoinositide 3-kinase regulates glycolysis through mobilization of aldolase from the actin cytoskeleton -- Aldolase mediates the association of F-actin with the insulin-responsive glucose transporter GLUT4 -- Targeting of several glycolytic enzymes using RNA interference reveals aldolase affects cancer cell proliferation through a non-glycolytic mechanism', 11),
('GADPH', 'GAPDH S-nitrosylation promotes its nuclear translocation and triggers apoptosis', 'Nucleus', 'Characterization of an aldolase-binding site in the Wiskott-Aldrich syndrome protein -- Phosphoinositide 3-kinase regulates glycolysis through mobilization of aldolase from the actin cytoskeleton -- Aldolase mediates the association of F-actin with the insulin-responsive glucose transporter GLUT4 -- Targeting of several glycolytic enzymes using RNA interference reveals aldolase affects cancer cell proliferation through a non-glycolytic mechanism', 12),
('GADPH', 'Facilitate apoptosis via including mitochondrial membrane permeabilization (MOMP) and subsequent release of cytochrome c and apoptosis-inducing factor', 'Mitochondria', 'Characterization of an aldolase-binding site in the Wiskott-Aldrich syndrome protein -- Phosphoinositide 3-kinase regulates glycolysis through mobilization of aldolase from the actin cytoskeleton -- Aldolase mediates the association of F-actin with the insulin-responsive glucose transporter GLUT4 -- Targeting of several glycolytic enzymes using RNA interference reveals aldolase affects cancer cell proliferation through a non-glycolytic mechanism', 13),
('PGK1', 'Recognizes primer and robustly stimulates DNA synthesis catalyzed by DNA polymerase alpha and epsilon', 'Nucleus', 'Immunoelectron microscopic analysis of the intracellular distribution of primer recognition proteins, annexin 2 and phosphoglycerate kinase, in normal and transformed cells -- Modulation of DNA polymerases alpha, delta and epsilon by lactate dehydrogenase and 3-phosphoglycerate kinase', 14),
('ENO1', 'MYC binding protein-1 (MBP-1) transcribes from the same gene as ENO1; MBP-1 binds to MYC and represses its expression by recruiting histone deacetylase (HDAC)', 'Nucleus', 'ENO1 gene product binds to the c-myc promoter and acts as a transcriptional repressor: relationship with Myc promoter-binding protein 1 (MBP-1) -- MBP-1 physically associates with histone deacetylase for transcriptional repression -- The activated Notch1 receptor cooperates with alpha-enolase and MBP-1 in modulating c-myc activity -- Identification of alpha-enolase as a nuclear DNA-binding protein in the zona fasciculata but not the zona reticularis of the human adrenal cortex', 15),
('ENO1', 'Attenuate Notxh1-mediated c-Myc activation by interacting with activated Notch1 receptor, N1IC', 'Nucleus', 'ENO1 gene product binds to the c-myc promoter and acts as a transcriptional repressor: relationship with Myc promoter-binding protein 1 (MBP-1) -- MBP-1 physically associates with histone deacetylase for transcriptional repression -- The activated Notch1 receptor cooperates with alpha-enolase and MBP-1 in modulating c-myc activity -- Identification of alpha-enolase as a nuclear DNA-binding protein in the zona fasciculata but not the zona reticularis of the human adrenal cortex', 16),
('PKM', 'Acts as a binding partner of Oct-4 and ehances its transcriptonal activity ', 'Nucleus', 'Pyruvate kinase M2 regulates gene transcription by acting as a protein kinase -- PKM2 regulates chromosome segregation and mitosis progression of tumor cells -- PKM2 phosphorylates MLC2 and regulates cytokinesis of tumour cells -- Pyruvate kinase isozyme type M2 (PKM2) interacts and cooperates with Oct-4 in regulating transcription -- Pyruvate kinase M2 is a PHD3-stimulated coactivator for hypoxia-inducible factor 1 -- JMJD5 regulates PKM2 nuclear translocation and reprograms HIF-1 alpha-mediated glucose metabolism -- Nuclear PKM2 regulates beta-catenin transactivation upon EGFR activation -- EGFR-induced and PKC epsilon monoubiquitylation-dependent NF-?B activation upregulates PKM2 expression and promotes tumorigenesis -- ERK1/2-dependent phosphorylation and nuclear translocation of PKM2 promotes the Warburg effect', 17),
('PKM', 'Interacts with HIF-1alpha and increases p300 recruitment to HIF target genes', 'Nucleus', 'Pyruvate kinase M2 regulates gene transcription by acting as a protein kinase -- PKM2 regulates chromosome segregation and mitosis progression of tumor cells -- PKM2 phosphorylates MLC2 and regulates cytokinesis of tumour cells -- Pyruvate kinase isozyme type M2 (PKM2) interacts and cooperates with Oct-4 in regulating transcription -- Pyruvate kinase M2 is a PHD3-stimulated coactivator for hypoxia-inducible factor 1 -- JMJD5 regulates PKM2 nuclear translocation and reprograms HIF-1 alpha-mediated glucose metabolism -- Nuclear PKM2 regulates beta-catenin transactivation upon EGFR activation -- EGFR-induced and PKC epsilon monoubiquitylation-dependent NF-?B activation upregulates PKM2 expression and promotes tumorigenesis -- ERK1/2-dependent phosphorylation and nuclear translocation of PKM2 promotes the Warburg effect', 18),
('PKM', 'Upon EGFR stimulation, PKM2 binds to beta-catenin and co-activates cyclin D1 and c-Myc', 'Nucleus', 'Pyruvate kinase M2 regulates gene transcription by acting as a protein kinase -- PKM2 regulates chromosome segregation and mitosis progression of tumor cells -- PKM2 phosphorylates MLC2 and regulates cytokinesis of tumour cells -- Pyruvate kinase isozyme type M2 (PKM2) interacts and cooperates with Oct-4 in regulating transcription -- Pyruvate kinase M2 is a PHD3-stimulated coactivator for hypoxia-inducible factor 1 -- JMJD5 regulates PKM2 nuclear translocation and reprograms HIF-1 alpha-mediated glucose metabolism -- Nuclear PKM2 regulates beta-catenin transactivation upon EGFR activation -- EGFR-induced and PKC epsilon monoubiquitylation-dependent NF-?B activation upregulates PKM2 expression and promotes tumorigenesis -- ERK1/2-dependent phosphorylation and nuclear translocation of PKM2 promotes the Warburg effect', 19),
('PKM', 'Kinase activity (controversial): PKM2 phosphorylates a variety of proteins, such as Stat3, histone H3, Bub3 and myosin light chain 2 (MLC2). PKM2 promotes G1/S transition by promoting cyclin D1 and c-Myc expression and chromosome segregation by phosphorylating spindle checkpoint protein Bub3', 'Nucleus / Cytosol', 'Pyruvate kinase M2 regulates gene transcription by acting as a protein kinase -- PKM2 regulates chromosome segregation and mitosis progression of tumor cells -- PKM2 phosphorylates MLC2 and regulates cytokinesis of tumour cells -- Pyruvate kinase isozyme type M2 (PKM2) interacts and cooperates with Oct-4 in regulating transcription -- Pyruvate kinase M2 is a PHD3-stimulated coactivator for hypoxia-inducible factor 1 -- JMJD5 regulates PKM2 nuclear translocation and reprograms HIF-1 alpha-mediated glucose metabolism -- Nuclear PKM2 regulates beta-catenin transactivation upon EGFR activation -- EGFR-induced and PKC epsilon monoubiquitylation-dependent NF-?B activation upregulates PKM2 expression and promotes tumorigenesis -- ERK1/2-dependent phosphorylation and nuclear translocation of PKM2 promotes the Warburg effect', 20),
('PKM', 'In yeast, Pyk1 (the yeast PKM2 homolog) forms the SESAME complex. SESAME interacts with Set1 methyltransferase and controls H3K4me3', 'Nucleus / Cystosol', 'Pyruvate kinase M2 regulates gene transcription by acting as a protein kinase -- PKM2 regulates chromosome segregation and mitosis progression of tumor cells -- PKM2 phosphorylates MLC2 and regulates cytokinesis of tumour cells -- Pyruvate kinase isozyme type M2 (PKM2) interacts and cooperates with Oct-4 in regulating transcription -- Pyruvate kinase M2 is a PHD3-stimulated coactivator for hypoxia-inducible factor 1 -- JMJD5 regulates PKM2 nuclear translocation and reprograms HIF-1 alpha-mediated glucose metabolism -- Nuclear PKM2 regulates beta-catenin transactivation upon EGFR activation -- EGFR-induced and PKC epsilon monoubiquitylation-dependent NF-?B activation upregulates PKM2 expression and promotes tumorigenesis -- ERK1/2-dependent phosphorylation and nuclear translocation of PKM2 promotes the Warburg effect', 21),
('LDHA', 'Forms OCA-S complex with GAPDH and regulates cell cycle progression', 'Nucleus', 'Nuclear lactate dehydrogenase modulates histone modification in human hepatocytes -- Modulation of DNA polymerases alpha, delta and epsilon by lactate dehydrogenase and 3-phosphoglycerate kinase -- S phase activation of the histone H2B promoter by OCA-S, a coactivator complex that contains GAPDH as a key component', 22),
('LDHA', 'Activates SIRT1 by supplementing NAD+', 'Nucleaus', 'Nuclear lactate dehydrogenase modulates histone modification in human hepatocytes -- Modulation of DNA polymerases alpha, delta and epsilon by lactate dehydrogenase and 3-phosphoglycerate kinase -- S phase activation of the histone H2B promoter by OCA-S, a coactivator complex that contains GAPDH as a key component', 23),
('LDHA', 'Binds to ssDNA and facilitates DNA replication by recruiting DNA polymerase alpha, delta and epsilon', 'Nucleus', 'Nuclear lactate dehydrogenase modulates histone modification in human hepatocytes -- Modulation of DNA polymerases alpha, delta and epsilon by lactate dehydrogenase and 3-phosphoglycerate kinase -- S phase activation of the histone H2B promoter by OCA-S, a coactivator complex that contains GAPDH as a key component', 24),
('ACO2', 'In yeast, aconitase (Aco1p) is essential for mitochondrial DNA (mtDNA) maintenance', 'Mitochondria', 'Aconitase couples metabolic regulation to mitochondrial DNA maintenance', 25),
('SUCLG1', 'SCS-A is associated with mtDNA maintenance', 'Mitochondria', 'Succinyl-CoA synthetase is a phosphate target for the activation of mitochondrial metabolism', 26),
('FH', 'Participates in DNA damage repair in an enzymatic-activity-dependent manner', 'Nucleus', 'Local generation of fumarate promotes DNA repair through inhibition of histone H3 demethylation -- Fumarase: a mitochondrial metabolic enzyme and a cytosolic/nuclear component of the DNA damage response', 27),
('MDH1', 'Increases p53 stabilization and transcriptonal activity by facilitating its phosphorylation and acetylation', 'Nucleus', 'A nucleocytoplasmic malate dehydrogenase regulates p53 transcriptional activity in response to metabolic stress -- Studies on energy-yielding reactions in thymus nuclei. 2. Pathways of aerobic carbohydrate catabolism', 28),
('MDH2', 'Increases p53 stabilization and transcriptonal activity by facilitating its phosphorylation and acetylation', 'Nucleus', 'A nucleocytoplasmic malate dehydrogenase regulates p53 transcriptional activity in response to metabolic stress -- Studies on energy-yielding reactions in thymus nuclei. 2. Pathways of aerobic carbohydrate catabolism', 29),
('PDC', 'Produces actelyl-CoA in the nucleus and increases histone acetylation', 'Nucleus', 'Acetyl-CoA induces cell growth and proliferation by promoting the acetylation of histones at growth genes -- HIF-1-mediated expression of pyruvate dehydrogenase kinase: a metabolic switch required for cellular adaptation to hypoxia -- A nuclear pyruvate dehydrogenase complex is important for the generation of Acetyl-CoA and histone acetylation', 30),
('PDC', 'Promotes cell cycle progression by increasing acetylation of histones important for G1/S transition and activating S-phase regulator expression (pRb, E2F, cyclin A and Cdk2)', 'Nucleus', 'Acetyl-CoA induces cell growth and proliferation by promoting the acetylation of histones at growth genes -- HIF-1-mediated expression of pyruvate dehydrogenase kinase: a metabolic switch required for cellular adaptation to hypoxia -- A nuclear pyruvate dehydrogenase complex is important for the generation of Acetyl-CoA and histone acetylation', 31),
('ACLY', 'Produces acetyl-CoA and increases histone actetylation', 'Nucleus', 'Akt-dependent metabolic reprogramming regulates tumor cell histone acetylation -- Nuclear acetyl-CoA production by ACLY promotes homologous recombination -- SWI/SNF nucleosome remodellers and cancer', 32),
('ACLY', 'Upon DNA damage, nuclear ACLY promotes homologus recombination', 'Nucleus', 'Akt-dependent metabolic reprogramming regulates tumor cell histone acetylation -- Nuclear acetyl-CoA production by ACLY promotes homologous recombination -- SWI/SNF nucleosome remodellers and cancer', 33),
('ACSS2', 'Forms a complex with TFEB and increases lysosomal and autophagy gene expression by local histone acetylation', 'Nucleus', 'Chen et al., 2015; Li et al., 2017a,b; Zhao et al., 2016', 34),
('ACSS2', 'Provides acetyl-CoA for lysine acetyltransferase CREB-binding protein (CBP)-mediated HIF-2alpha acetylation', 'Not specified', 'The acetate/ACSS2 switch regulates HIF-2 stress signaling in the tumor cell microenvironment -- Local histone acetylation by ACSS2 promotes gene transcription for lysosomal biogenesis and autophagy -- Nucleus-translocated ACSS2 promotes gene transcription for lysosomal biogenesis and autophagy -- ATP-citrate lyase controls a glucose-to-acetate metabolic switch', 35),
('ACSS2', 'Increases histone acetylation near the sites of neuronal genes and upreglates their expression in neuronal cells', 'Nucleus', 'The acetate/ACSS2 switch regulates HIF-2 stress signaling in the tumor cell microenvironment -- Local histone acetylation by ACSS2 promotes gene transcription for lysosomal biogenesis and autophagy -- Nucleus-translocated ACSS2 promotes gene transcription for lysosomal biogenesis and autophagy -- ATP-citrate lyase controls a glucose-to-acetate metabolic switch', 36),
('MAT2A', 'Forms a complex with Maf and represses HMOX1 expression by increasing histone methylation and recruiting chromatin co-repressors', 'Nucleus', 'Methionine adenosyltransferase II serves as a transcriptional corepressor of Maf oncoprotein', 37),
('SHMT-1', 'Directs deubiquitinating complex BRISC to IFAR1 and protects it from lysosomal degradation and promotes IFNAR1 signaling', 'Cytosol', 'A BRISC-SHMT complex deubiquitinates IFNAR1 and regulates interferon responses', 38);

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `canonic`
--
ALTER TABLE `canonic`
  ADD PRIMARY KEY (`num_can`);

--
-- Index pour la table `ncanonic`
--
ALTER TABLE `ncanonic`
  ADD PRIMARY KEY (`num_ncan`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `canonic`
--
ALTER TABLE `canonic`
  MODIFY `num_can` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT pour la table `ncanonic`
--
ALTER TABLE `ncanonic`
  MODIFY `num_ncan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
