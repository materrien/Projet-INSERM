-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le :  ven. 13 déc. 2019 à 13:46
-- Version du serveur :  5.7.26
-- Version de PHP :  7.2.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `non_canonic`
--

-- --------------------------------------------------------

--
-- Structure de la table `canonic`
--

DROP TABLE IF EXISTS `canonic`;
CREATE TABLE IF NOT EXISTS `canonic` (
  `Gene_Symbol` varchar(20) NOT NULL,
  `Gene_Name` varchar(200) NOT NULL,
  `C_Pathway` varchar(1000) NOT NULL,
  `C_Loc` varchar(1000) NOT NULL,
  `num_can` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`num_can`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4;

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

DROP TABLE IF EXISTS `ncanonic`;
CREATE TABLE IF NOT EXISTS `ncanonic` (
  `Gene_Symbol` varchar(20) NOT NULL,
  `NC_Pathway` varchar(1000) NOT NULL,
  `NC_Loc` varchar(1000) NOT NULL,
  `num_ncan` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`num_ncan`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `ncanonic`
--

INSERT INTO `ncanonic` (`Gene_Symbol`, `NC_Pathway`, `NC_Loc`, `num_ncan`) VALUES
('HK2', 'Repress the expression of genes involved in glucose repression', 'Cytosol', 1),
('HK2', 'Protect cells from apotosis by regulating the mitochondrial permeability transition pore and by limiting the production of reactive oxygen species', 'Mitochondria', 2),
('GPI', 'Act as an autocrine factor extracellulary to elicit cell migration and proliferation', 'Extracellular localization', 3),
('PFKM', 'Bind to transcription factor TEAD and stabilize its interaction with YAP/TAZ, and promote gene expression', 'Nucleus', 4),
('PFKFB3', 'Promote cell cycle progression by upregulating cell cycle protein expression and downregulating cell cycle inhibitor p27', 'Nucleus', 5),
('FBP1', 'Bind to hypoxia-inducible factors (HIFs) and inhibit their transcriptional activation of glycolytic gene expression', 'Nucleus', 6),
('ALDOA', 'Participate in cytokinesis through its interaction with F-actin and Wiskott-Aldrich syndrome protein (WASP) family protein', 'Cytoskeleton', 7),
('GADPH', 'Bind to colony-stimulating factor-1 (CSF-1) mRNA and stabilize its transcripts', 'Nucleus', 8),
('GADPH', 'Function as a key component in the OCA-S complex, mediate its activation of H2B during S phase and promote cell cycle progression', 'Nucleus', 9),
('GADPH', 'Protects telomeres against rapid shortening', 'Nucleus', 10),
('GADPH', 'Increases DNA synthesis during S phase vie direct binding to single-stranded DNA (ssDNA) and stimulating the DNA-polymerase-alpha-primase complex', 'Nucleus', 11),
('GADPH', 'GAPDH S-nitrosylation promotes its nuclear translocation and triggers apoptosis', 'Nucleus', 12),
('GADPH', 'Facilitate apoptosis via including mitochondrial membrane permeabilization (MOMP) and subsequent release of cytochrome c and apoptosis-inducing factor', 'Mitochondria', 13),
('PGK1', 'Recognizes primer and robustly stimulates DNA synthesis catalyzed by DNA polymerase alpha and epsilon', 'Nucleus', 14),
('ENO1', 'MYC binding protein-1 (MBP-1) transcribes from the same gene as ENO1; MBP-1 binds to MYC and represses its expression by recruiting histone deacetylase (HDAC)', 'Nucleus', 15),
('ENO1', 'Attenuate Notxh1-mediated c-Myc activation by interacting with activated Notch1 receptor, N1IC', 'Nucleus', 16),
('PKM', 'Acts as a binding partner of Oct-4 and ehances its transcriptonal activity ', 'Nucleus', 17),
('PKM', 'Interacts with HIF-1alpha and increases p300 recruitment to HIF target genes', 'Nucleus', 18),
('PKM', 'Upon EGFR stimulation, PKM2 binds to beta-catenin and co-activates cyclin D1 and c-Myc', 'Nucleus', 19),
('PKM', 'Kinase activity (controversial): PKM2 phosphorylates a variety of proteins, such as Stat3, histone H3, Bub3 and myosin light chain 2 (MLC2). PKM2 promotes G1/S transition by promoting cyclin D1 and c-Myc expression and chromosome segregation by phosphorylating spindle checkpoint protein Bub3', 'Nucleus / Cytosol', 20),
('PKM', 'In yeast, Pyk1 (the yeast PKM2 homolog) forms the SESAME complex. SESAME interacts with Set1 methyltransferase and controls H3K4me3', 'Nucleus / Cystosol', 21),
('LDHA', 'Forms OCA-S complex with GAPDH and regulates cell cycle progression', 'Nucleus', 22),
('LDHA', 'Activates SIRT1 by supplementing NAD+', 'Nucleaus', 23),
('LDHA', 'Binds to ssDNA and facilitates DNA replication by recruiting DNA polymerase alpha, delta and epsilon', 'Nucleus', 24),
('ACO2', 'In yeast, aconitase (Aco1p) is essential for mitochondrial DNA (mtDNA) maintenance', 'Mitochondria', 25),
('SUCLG1', 'SCS-A is associated with mtDNA maintenance', 'Mitochondria', 26),
('FH', 'Participates in DNA damage repair in an enzymatic-activity-dependent manner', 'Nucleus', 27),
('MDH1', 'Increases p53 stabilization and transcriptonal activity by facilitating its phosphorylation and acetylation', 'Nucleus', 28),
('MDH2', 'Increases p53 stabilization and transcriptonal activity by facilitating its phosphorylation and acetylation', 'Nucleus', 29),
('PDC', 'Produces actelyl-CoA in the nucleus and increases histone acetylation', 'Nucleus', 30),
('PDC', 'Promotes cell cycle progression by increasing acetylation of histones important for G1/S transition and activating S-phase regulator expression (pRb, E2F, cyclin A and Cdk2)', 'Nucleus', 31),
('ACLY', 'Produces acetyl-CoA and increases histone actetylation', 'Nucleus', 32),
('ACLY', 'Upon DNA damage, nuclear ACLY promotes homologus recombination', 'Nucleus', 33),
('ACSS2', 'Forms a complex with TFEB and increases lysosomal and autophagy gene expression by local histone acetylation', 'Nucleus', 34),
('ACSS2', 'Provides acetyl-CoA for lysine acetyltransferase CREB-binding protein (CBP)-mediated HIF-2alpha acetylation', 'Not specified', 35),
('ACSS2', 'Increases histone acetylation near the sites of neuronal genes and upreglates their expression in neuronal cells', 'Nucleus', 36),
('MAT2A', 'Forms a complex with Maf and represses HMOX1 expression by increasing histone methylation and recruiting chromatin co-repressors', 'Nucleus', 37),
('SHMT-1', 'Directs deubiquitinating complex BRISC to IFAR1 and protects it from lysosomal degradation and promotes IFNAR1 signaling', 'Cytosol', 38);

-- --------------------------------------------------------

--
-- Structure de la table `references`
--

DROP TABLE IF EXISTS `references`;
CREATE TABLE IF NOT EXISTS `references` (
  `id_ref` int(11) NOT NULL AUTO_INCREMENT,
  `Gene_Symbol` varchar(20) NOT NULL,
  `ref` varchar(1000) NOT NULL,
  PRIMARY KEY (`id_ref`)
) ENGINE=MyISAM AUTO_INCREMENT=74 DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `references`
--

INSERT INTO `references` (`id_ref`, `Gene_Symbol`, `ref`) VALUES
(1, 'HK2', 'The glucoseregulated nuclear localization of hexokinase 2 in Saccharomyces cerevisiae is Mig1-dependent'),
(2, 'HK2', 'Mitochondrial localization of TIGAR under hypoxia stimulates HK2 and lowers ROS and cell death'),
(3, 'HK2', 'Hexokinase II detachment from mitochondria triggers apoptosis through the permeability transition pore independent of voltage-dependent anion channels'),
(4, 'HK2', 'Inhibition of early apoptotic events by Akt/PKB is dependent on the first committed step of glycolysis and mitochondrial hexokinase'),
(5, 'HK2', 'Hexokinase-mitochondria interaction mediated by Akt is required to inhibit apoptosis in the presence or absence of Bax and Bak'),
(6, 'HK2', 'Mitochondrial binding of hexokinase II inhibits Bax-induced cytochrome c release and apoptosis'),
(7, 'GPI', 'Phosphoglucose isomerase/autocrine motility factor mediates epithelial-mesenchymal transition regulated by miR-200 in breast cancer cells'),
(8, 'GPI', 'Autocrine motility factor/phosphoglucose isomerase regulates ER stress and cell death through control of ER calcium release'),
(9, 'GPI', 'Regulation of phosphoglucose isomerase/autocrine motility factor expression by hypoxia'),
(10, 'GPI', 'The crystal structure of a multifunctional protein: phosphoglucose isomerase/autocrine motility factor/neuroleukin'),
(11, 'GPI', 'Tumor cell autocrine motility factor is the neuroleukin/phosphohexose isomerase polypeptide'),
(12, 'PFKM', 'Aerobic glycolysis tunes YAP/TAZ transcriptional activity'),
(13, 'PFKFB3', '6-Phosphofructo-2-kinase (PFKFB3) promotes cell cycle progression and suppresses apoptosis via Cdk1-mediated phosphorylation of p27'),
(14, 'PFKFB3', 'Nuclear targeting of 6-phosphofructo-2-kinase (PFKFB3) increases proliferation via cyclin-dependent kinases'),
(15, 'FBP1', 'Fructose-1,6-bisphosphatase opposes renal carcinoma progression'),
(17, 'ALDOA', 'Characterization of an aldolase-binding site in the Wiskott-Aldrich syndrome protein'),
(18, 'ALDOA', 'Phosphoinositide 3-kinase regulates glycolysis through mobilization of aldolase from the actin cytoskeleton'),
(19, 'ALDOA', 'Aldolase mediates the association of F-actin with the insulin-responsive glucose transporter GLUT4'),
(20, 'ALDOA', 'Targeting of several glycolytic enzymes using RNA interference reveals aldolase affects cancer cell proliferation through a non-glycolytic mechanism'),
(21, 'GAPDH', 'Inhibition of early apoptotic events by Akt/PKB is dependent on the first committed step of glycolysis and mitochondrial hexokinase'),
(22, 'GAPDH', 'S-nitrosylated GAPDH initiates apoptotic cell death by nuclear translocation following Siah1 binding'),
(23, 'GAPDH', 'Nitric oxide-induced nuclear GAPDH activates p300/CBP and mediates apoptosis'),
(24, 'GAPDH', 'Rapid shortening of telomere length in response to ceramide involves the inhibition of telomere binding activity of nuclear glyceraldehyde-3-phosphate dehydrogenase'),
(25, 'GAPDH', 'S phase activation of the histone H2B promoter by OCA-S, a coactivator complex that contains GAPDH as a key component'),
(26, 'GAPDH', 'The multifunctional protein glyceraldehyde-3-phosphate dehydrogenase is both regulated and controls colony stimulating factor-1 messenger RNA stability in ovarian cancer'),
(27, 'PGK1', 'Immunoelectron microscopic analysis of the intracellular distribution of primer recognition proteins, annexin 2 and phosphoglycerate kinase, in normal and transformed cells'),
(28, 'PGK1', 'Modulation of DNA polymerases alpha, delta and epsilon by lactate dehydrogenase and 3-phosphoglycerate kinase'),
(29, 'ENO1', 'ENO1 gene product binds to the c-myc promoter and acts as a transcriptional repressor: relationship with Myc promoter-binding protein 1 (MBP-1)'),
(30, 'ENO1', 'MBP-1 physically associates with histone deacetylase for transcriptional repression'),
(31, 'ENO1', 'The activated Notch1 receptor cooperates with alpha-enolase and MBP-1 in modulating c-myc activity'),
(32, 'ENO1', 'Identification of alpha-enolase as a nuclear DNA-binding protein in the zona fasciculata but not the zona reticularis of the human adrenal cortex'),
(33, 'PKM', 'Pyruvate kinase M2 regulates gene transcription by acting as a protein kinase'),
(34, 'PKM', 'PKM2 regulates chromosome segregation and mitosis progression of tumor cells'),
(35, 'PKM', 'PKM2 phosphorylates MLC2 and regulates cytokinesis of tumour cells'),
(36, 'PKM', 'Pyruvate kinase isozyme type M2 (PKM2) interacts and cooperates with Oct-4 in regulating transcription'),
(37, 'PKM', 'Pyruvate kinase M2 is a PHD3-stimulated coactivator for hypoxia-inducible factor 1'),
(38, 'PKM', 'JMJD5 regulates PKM2 nuclear translocation and reprograms HIF-1 alpha-mediated glucose metabolism'),
(39, 'PKM', 'Nuclear PKM2 regulates beta-catenin transactivation upon EGFR activation'),
(51, 'LDHA', 'S phase activation of the histone H2B promoter by OCA-S, a coactivator complex that contains GAPDH as a key component'),
(50, 'LDHA', 'Modulation of DNA polymerases alpha, delta and epsilon by lactate dehydrogenase and 3-phosphoglycerate '),
(49, 'LDHA', 'Nuclear lactate dehydrogenase modulates histone modification in human hepatocytes'),
(48, 'PKM', 'ERK1/2-dependent phosphorylation and nuclear translocation of PKM2 promotes the Warburg effect'),
(47, 'PKM', 'EGFR-induced and PKC epsilon monoubiquitylation-dependent NF-kB activation upregulates PKM2 expression and promotes tumorigenesis'),
(52, 'ACO2', 'Aconitase couples metabolic regulation to mitochondrial DNA maintenance'),
(53, 'SUCLG1', 'Succinyl-CoA synthetase is a phosphate target for the activation of mitochondrial metabolism'),
(54, 'FH', 'Local generation of fumarate promotes DNA repair through inhibition of histone H3 demethylation'),
(55, 'FH', 'Fumarase: a mitochondrial metabolic enzyme and a cytosolic/nuclear component of the DNA damage response'),
(71, 'MDH1', 'Studies on energy-yielding reactions in thymus nuclei. 2. Pathways of aerobic carbohydrate catabolism'),
(70, 'MDH1', 'A nucleocytoplasmic malate dehydrogenase regulates p53 transcriptional activity in response to metabolic stress'),
(58, 'PDC', 'Acetyl-CoA induces cell growth and proliferation by promoting the acetylation of histones at growth genes'),
(59, 'PDC', 'HIF-1-mediated expression of pyruvate dehydrogenase kinase: a metabolic switch required for cellular adaptation to hypoxia'),
(60, 'PDC', 'A nuclear pyruvate dehydrogenase complex is important for the generation of Acetyl-CoA and histone acetylation'),
(61, 'ACLY', 'Akt-dependent metabolic reprogramming regulates tumor cell histone acetylation'),
(62, 'ACLY', 'Nuclear acetyl-CoA production by ACLY promotes homologous recombination'),
(63, 'ACLY', 'SWI/SNF nucleosome remodellers and cancer'),
(64, 'ACSS2', 'The acetate/ACSS2 switch regulates HIF-2 stress signaling in the tumor cell microenvironment'),
(65, 'ACSS2', 'Local histone acetylation by ACSS2 promotes gene transcription for lysosomal biogenesis and autophagy'),
(66, 'ACSS2', 'Nucleus-translocated ACSS2 promotes gene transcription for lysosomal biogenesis and autophagy'),
(67, 'ACSS2', 'ATP-citrate lyase controls a glucose-to-acetate metabolic switch'),
(68, 'MAT2A', 'Methionine adenosyltransferase II serves as a transcriptional corepressor of Maf oncoprotein'),
(69, 'SHMT-1', 'A BRISC-SHMT complex deubiquitinates IFNAR1 and regulates interferon responses'),
(72, 'MDH2', 'A nucleocytoplasmic malate dehydrogenase regulates p53 transcriptional activity in response to metabolic stress'),
(73, 'MDH2', 'Studies on energy-yielding reactions in thymus nuclei. 2. Pathways of aerobic carbohydrate catabolism');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
