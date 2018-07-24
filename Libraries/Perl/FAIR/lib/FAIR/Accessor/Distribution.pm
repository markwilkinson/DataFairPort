package FAIR::Accessor::Distribution;
use strict;
use Moose;
use Data::UUID;
use RDF::Trine::Store::Memory;
use RDF::Trine::Model;

with 'FAIR::CoreFunctions';

has 'NS' => (
    is => 'rw',
);

has 'downloadURL'=> (
      is => 'rw',
      isa => 'Str',
);

has 'source'=> (
      is => 'rw',
      isa => 'Str',
);

has 'URI'=> (
      is => 'rw',
      isa => 'Str',
);

has 'subjecttemplate'=> (
      is => 'rw',
      isa => 'Str',
);

has 'subjecttype'=> (
      is => 'rw',
      isa => 'Str',
);

has 'predicate'=> (
      is => 'rw',
      isa => 'Str',
);

has 'objecttemplate'=> (
      is => 'rw',
      isa => 'Str',
);

has 'objecttype'=> (
      is => 'rw',
      isa => 'Str',
);

has 'availableformats'=> (
      is => 'rw',
      isa => 'ArrayRef[Str]',
);

has 'distributionType' => (
      is => 'rw',
      isa => 'ArrayRef',
      default => sub {["dcat:Distribution", "dc:Dataset"]},
);

has 'baseURI' => (
      is => 'rw',
      isa => 'Str',
      default => "http://datafairport.org/local/Source",
);


has 'UUID' => (
      is => 'rw',
      isa => 'Str',
      default => sub { my $ug =Data::UUID->new; my $uuid = $ug->create(); return $ug->to_string( $uuid ) }
);

#has 'model' => (
#      is => 'rw',
#      isa => 'RDF::Trine::Model',
#      default => sub {my $store = RDF::Trine::Store::Memory->new(); return RDF::Trine::Model->new($store)}
#);

has 'Projectionmodel' => (
    isa => "RDF::Trine::Model",
    is => "rw",
    default => sub {my $store = RDF::Trine::Store::Memory->new(); return RDF::Trine::Model->new($store)}
);



sub BUILD {
      my $self = shift;
      my $uuid = $self->UUID();
      my $prefix = "http://" . $ENV{HTTP_HOST} . $ENV{REQUEST_URI};
      my $URI = $prefix . "#Distribution$uuid";
      $self->URI($URI);
}


sub types {
      my ($self) = @_;
      my $formats = $self->availableformats();
      my $formatstr = join ",", @$formats;
      my @types = @{$self->distributionType};
      if (($formatstr =~/turtle/) || ($formatstr =~ /rdf/) || ($formatstr =~ /quads/)) {
            push @types, "void:Dataset";
      }
      
      if ($self->source) {  # if it has this, then it is TPF
            push @types, "fair:Projector";
      }
      return @types;
}

sub ProjectionModel {
    my ($self) = @_;
    my $uuid = $self->UUID();
    my $NS = $self->NS();

    my $model = $self->Projectionmodel;

    my $prefix = "http://" . $ENV{HTTP_HOST} . $ENV{REQUEST_URI};
    
    #my $URI = $prefix . "#Distribution$uuid";
    my $URI = $self->URI();

    my $SRC = $prefix . "#Source$uuid";
    my $MAP = $prefix . "#Mappings$uuid";
    my $SMAP = $prefix . "#SubjectMap$uuid";
    my $POMAP = $prefix . "#POMap$uuid";
    my $OMAP =  $prefix . "#ObjectMap$uuid";
    my $MAP2 = $prefix . "#Mappings$uuid";
    my $SMAP2 = $prefix . "#SubjectMap2$uuid";
    
    my $statement;
    
    $statement = $self->makeSensibleStatement($MAP, $self->NS->rdf('type'), $self->NS->rr('TriplesMap'));
    $model->add_statement($statement);
    $statement = $self->makeSensibleStatement($SMAP, $self->NS->rdf('type'), $self->NS->rr('SubjectMap'));
    $model->add_statement($statement);
    $statement = $self->makeSensibleStatement($POMAP, $self->NS->rdf('type'), $self->NS->rr('predicateObjectMap'));
    $model->add_statement($statement);
    $statement = $self->makeSensibleStatement($OMAP, $self->NS->rdf('type'), $self->NS->rr('ObjectMap'));
    $model->add_statement($statement);
    $statement = $self->makeSensibleStatement($MAP2, $self->NS->rdf('type'), $self->NS->rr('TriplesMap'));
    $model->add_statement($statement);
    $statement = $self->makeSensibleStatement($SMAP2, $self->NS->rdf('type'), $self->NS->rr('SubjectMap'));
    $model->add_statement($statement);
     
            
   my $statement;

    $statement = $self->makeSensibleStatement($URI, $self->NS->rml('hasMapping'), $MAP);
    $model->add_statement($statement);

    $statement = $self->makeSensibleStatement($MAP, $self->NS->rml('logicalSource'), $SRC);
    $model->add_statement($statement);

        
#    $statement = $self->makeSensibleStatement($SRC, $self->NS->rml('source'), $self->source);
#    $model->add_statement($statement);       
    
        #  <SRC>  rml:referenceFormulation  ql:CSV
    $statement = $self->makeSensibleStatement($SRC, $self->NS->rml('referenceFormulation'), $self->NS->ql('TriplePatternFragments'));
    $model->add_statement($statement);


        
        # <MAP> rr:subjectMap <SMAP>
    $statement = $self->makeSensibleStatement($MAP, $self->NS->rr('subjectMap'), $SMAP);
    $model->add_statement($statement);
        # <SMAP> rr:template "http://something/{ID}"


   my $templateurl = RDF::Trine::Node::Literal->new($self->subjecttemplate);
    $statement = $self->makeSensibleStatement($SMAP, $self->NS->rr('template'), $templateurl);
    $model->add_statement($statement);

    $statement = $self->makeSensibleStatement($SMAP, $self->NS->rr('class'), $self->subjecttype);
    $model->add_statement($statement);

    
    
        # <MAP>  rr:predicateObjectMap <POMAP>
    $statement = $self->makeSensibleStatement($MAP, $self->NS->rr('predicateObjectMap'), $POMAP);
    $model->add_statement($statement);
        #
        # <POMAP>  rr:predicate {$predicate}
    $statement = $self->makeSensibleStatement($POMAP, $self->NS->rr('predicate'), $self->predicate);
    $model->add_statement($statement);
        # <POMAP>  rr:objectMap <OMAP>
    $statement = $self->makeSensibleStatement($POMAP, $self->NS->rr('objectMap'), $OMAP);
    $model->add_statement($statement);
    
    
        #
        #
        # <OMAP> rr:parentTriplesMap <OBJMAP>
    $statement = $self->makeSensibleStatement($OMAP, $self->NS->rr('parentTriplesMap'), $MAP2);
    $model->add_statement($statement);
    $statement = $self->makeSensibleStatement($MAP2, $self->NS->rr('subjectMap'), $SMAP2);
    $model->add_statement($statement);
        # <OMAP> rr:subjecctMap <SMAP2>
        # <SMAP2>  rr:template "http://somethingelse/{out}


if ($self->objecttype =~ /\#string/){
        $templateurl = RDF::Trine::Node::Literal->new("{value}");
    } else {
        $templateurl = RDF::Trine::Node::Literal->new($self->objecttemplate);
    }
    $statement = $self->makeSensibleStatement($SMAP2, $self->NS->rr('template'), $templateurl);
    $model->add_statement($statement);

    $statement = $self->makeSensibleStatement($SMAP2, $self->NS->rr('class'), $self->objecttype);
    $model->add_statement($statement);

    return $model;

}

sub makeSensibleStatement {
      my ($self, $s, $p, $o) = @_;
	my ($subject, $predicate, $object);
      my $NS = $self->NS();
      
      if (($s =~ /^http:/) || ($s =~ /^https:/) || ref($s)) {
		$subject = $s;
      } else {
             my ($ns, $sub) = split /:/, $s;
             $subject = $NS->$ns($sub);   # add the namespace   
      }
      
      if (($p =~ /^http:/) || ($p =~ /^https:/) || ref($p)) {
	$predicate = $p;
      } else {
             my ($ns, $pred) = split /:/, $p;
             $predicate = $NS->$ns($pred);   # add the namespace   
      }
         
      if (($o =~ /^http:/) || ($o =~ /^https:/) || ref($o)) {  # if its a URL or an object
            $object = $o
      } elsif ((!($o =~ /\s/)) && ($o =~ /\S+:\S+/)){  # if it looks like a qname tag
            my ($ns,$obj) = split /:/, $o;
            if ($NS->$ns($obj)) {
                  $object =  $NS->$ns($obj);   # add the namespace               
            }
      } else {
		$object = $o
	}
         
      my $statement = statement($subject,  $predicate, $object); 
      
      return $statement;
      
}


1;
