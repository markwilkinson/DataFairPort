#!perl -w
use lib "../lib/";
use FAIR::Profile;
use FAIR::Profile::Class;
use FAIR::Profile::Property;
use FAIR::NAMESPACES;

my $MicroarrayDatasetSchema = FAIR::Profile->new(
                label => 'Microarray Deposition for Fairport Demo',
		title => "A very very simple data deposition descriptor", 
		description => "This FAIR Profile defines a schema that will have a DCAT Dataset with title, description, issued, and distribution properties",
                license => "Anyone may use this freely",
                issued => "May 26, 2014",
    		organization => "wilkinsonlab.info",
		identifier => "doi:2222222222",
                URI => "http://biordf.org/DataFairPort/ProfileSchemas/DemoMicroarrayProfileScheme.rdf",
                );

my $ORCIDSchema = FAIR::Profile->new(
                label => 'Metadata around an ORCID record',
		title => "Simple ORCID record descriptor", 
		description => "Just the ORCID ID and its resolvable URL",
                license => "Anyone may use this freely",
                issued => "May 26, 2014",
    		organization => "wilkinsonlab.info",
		identifier => "doi:33333333333",
                URI => "http://biordf.org/DataFairPort/ProfileSchemas/DemoORCIDProfileScheme.rdf",
                );


# ==  ORCID Class

my $ORCIDClass = FAIR::Profile::Class->new(
    #class_type => "http://biordf.org/DataFairPort/ProfileSchemas/DemoORCIDProfileScheme.rdf",
    URI => "http://biordf.org/DataFairPort/ProfileSchemas/DemoORCIDProfileScheme.rdf#ORCID",
    label => "ORCID Records",
    _template => 'http://biordf.org/DataFairPort/ProfileSchemas/Templates/ORCID.tt',
   );

    
    my $IDProperty = FAIR::Profile::Property->new(
        property_type => 'http://datafairport.org/examples/ProfileSchemas/Examples/ORCID_Class#orcid_id',
        label => "ORCID ID",
    );
    $IDProperty->set_MinCount('1');
    $IDProperty->set_MaxCount('1');
    $IDProperty->add_ValueRange(XSD."string");
    $ORCIDClass->add_Property($IDProperty);
    
    my $ORCID_URL = FAIR::Profile::Property->new(
        property_type => 'http://datafairport.org/examples/ProfileSchemas/Examples/ORCID_Class#orcid_url',
        label => "ORCID URL",

    );
    $ORCID_URL->set_MinCount('1');
    $ORCID_URL->set_MaxCount('1');
    $ORCID_URL->add_ValueRange(XSD."anyURI");
    $ORCIDClass->add_Property($ORCID_URL);


# ===== DCAT Distribution Class
my $DCATDistributionClass = FAIR::Profile::Class->new(
    class_type => FAIR."Profile",
    URI => "http://biordf.org/DataFairPort/ProfileSchemas/DemoMicroarrayProfileScheme.rdf#CoreMicroarrayDistributionMetadata",
    label => "Core Microarray Data Distribution Metadata",
    _template => 'http://biordf.org/DataFairPort/ProfileSchemas/Templates/MicroarrayDistribution.tt',
   );

    my $TitleProperty = FAIR::Profile::Property->new(
        property_type => DC.'title',
        label => "Title",
    );
    $TitleProperty->set_MinCount('1');
    $TitleProperty->set_MaxCount('1');
    $TitleProperty->add_ValueRange(XSD."string");
    $DCATDistributionClass->add_Property($TitleProperty);
    
    
    my $DescrProperty = FAIR::Profile::Property->new(
        property_type => DC.'description',
        label => "Description",
    );
    $DescrProperty->set_MinCount('1');
    $DescrProperty->set_MaxCount('1');
    $DescrProperty->add_ValueRange(XSD."string");
    $DCATDistributionClass->add_Property($DescrProperty);
    
    
    my $IssuedProperty = FAIR::Profile::Property->new(
        property_type => DC.'mediaType',
        label => "mediaType (controlled vocabulary)",
    );
    $IssuedProperty->set_MinCount('1');
    $IssuedProperty->set_MaxCount('1');
    $IssuedProperty->add_ValueRange("http://biordf.org/DataFairPort/ConceptSchemes/EDAM_Microarray_Data_Format");
    $DCATDistributionClass->add_Property($IssuedProperty);
#------------------------------

# ==== Extended Authorship Class
my $ExtendedAuthorshipClass = FAIR::Profile::Class->new(
    class_type => "http://biordf.org/DataFairPort/ProfileSchemas/DemoMicroarrayProfileScheme.rdf#ExtendedAuthorship",
    URI => "http://biordf.org/DataFairPort/ProfileSchemas/DemoMicroarrayProfileScheme.rdf#ExtendedAuthorship",
    label => "Extended Authorship Information",
    _template => 'http://biordf.org/DataFairPort/ProfileSchemas/Templates/ExtendedAuthorship.tt',
   );

    my $AuthorProperty = FAIR::Profile::Property->new(
        property_type => DC.'Creator',
        label => "Creator (free)",
    );
    $AuthorProperty->set_MinCount('1');
    $AuthorProperty->set_MaxCount('1');
    $AuthorProperty->add_ValueRange(XSD."string");
    $ExtendedAuthorshipClass->add_Property($AuthorProperty);
    
    
    my $ExtendedAuthorProperty = FAIR::Profile::Property->new(
        property_type => "http://datafairport.org/examples/ProfileSchemas/ExtendedAuthorshipMetadata.rdf#author_details",
        label => "Author ORCID",
    );
    $ExtendedAuthorProperty->set_MinCount('1');
    $ExtendedAuthorProperty->set_MaxCount('1');
    $ExtendedAuthorProperty->add_ValueRange("http://biordf.org/DataFairPort/ProfileSchemas/DemoORCIDProfileScheme.rdf");
    $ExtendedAuthorshipClass->add_Property($ExtendedAuthorProperty);
#----------------------------


#============= Microarray Metadata

my $MicroarrayMetadataClass = FAIR::Profile::Class->new(
    class_type => "http://biordf.org/DataFairPort/ProfileSchemas/DemoMicroarrayProfileScheme.rdf#MicroarrayMetadata",
    URI => "http://biordf.org/DataFairPort/ProfileSchemas/DemoMicroarrayProfileScheme.rdf#MicroarrayMetadata",
    label => "Microarray Generation Protocol Metadata",
    _template => 'http://biordf.org/DataFairPort/ProfileSchemas/Templates/MicroarrayMetadata.tt',

   );

    
    my $ProtocolProperty = FAIR::Profile::Property->new(
        property_type => 'http://datafairport.org/examples/ProfileSchemas/MicroarrayMetadata.rdf#generated_by_protocol',
        label => "generated by protocol (free text)",
    );
    $ProtocolProperty->set_MinCount('1');
    $ProtocolProperty->set_MaxCount('1');
    $ProtocolProperty->add_ValueRange(XSD."string");
    $MicroarrayMetadataClass->add_Property($ProtocolProperty);
    
    my $ProtocolType = FAIR::Profile::Property->new(
        property_type => 'http://datafairport.org/examples/ProfileSchemas/MicroarrayMetadata.rdf#protocol_type',
        label => "generated by prootocol type (limited by EFO ontology)",
    );
    $ProtocolType->add_ValueRange('http://biordf.org/DataFairPort/ConceptSchemes/EFO_Gene_Expression_Protocol');
    $MicroarrayMetadataClass->add_Property($ProtocolType);
#-----------------------


# add the three metadata classes to the Microarray profile
$MicroarrayDatasetSchema->add_Class($MicroarrayMetadataClass);
$MicroarrayDatasetSchema->add_Class($ExtendedAuthorshipClass);
$MicroarrayDatasetSchema->add_Class($DCATDistributionClass);

my $schemardf =  $MicroarrayDatasetSchema->serialize;
open(OUT, ">DemoMicroarrayProfileScheme.rdf") or die "Can't open the output file to write the profile schema$!\n";
print $schemardf, "\n\n================================\n\n";
print OUT $schemardf;
close OUT;

#-------------

# add the single metadata class to the ORCID profile
$ORCIDSchema->add_Class($ORCIDClass);

my $schema2rdf =  $ORCIDSchema->serialize;
open(OUT, ">DemoORCIDProfileScheme.rdf") or die "Can't open the output file to write the profile schema$!\n";
print $schema2rdf, "\n";
print OUT $schema2rdf;
close OUT;
    


