unit Core;

interface //#################################################################### ■

uses FMX.Types, FMX.TreeView,
     LUX.Data.Tree;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TMyNode

     TMyNode = class( TTreeNode<TMyNode> )
     private
     protected
     public
       Name :String;
       /////
       constructor Create; override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TMyMaterialSource

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

function RandString( const N_:Integer ) :String;

procedure ShowTree( const TreeView_:TTreeView; const Root_:TMyNode );

function RandNode( const Node_:TMyNode ) :TMyNode;
function RandKnot( const Node_:TMyNode ) :TMyNode;

function FindNode( const Node_:TMyNode ) :TMyNode;
function FindKnot( const Knot_:TMyNode ) :TMyNode;
function FindLeaf( const Node_:TMyNode ) :TMyNode;

procedure AddNode( const Root_:TMyNode );
procedure TransNode( const Root0_,Root1_:TMyNode );
procedure SwapSibliNodes( const Root_:TMyNode );
procedure SwapOtherNodes( const Root1_,Root2_:TMyNode );
procedure DelNode( const Root_:TMyNode );

implementation //############################################################### ■

uses System.SysUtils;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TMyNode

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TMyNode.Create;
begin
     inherited;

     Name := RandString( 8 );
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

function RandString( const N_:Integer ) :String;
const
     Cs = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
var
   I :Integer;
begin
     Result := '';

     for I := 1 to N_ do Result := Result + Cs.Chars[ Random( 26 ) ];
end;

//------------------------------------------------------------------------------

procedure ShowTree( const TreeView_:TTreeView; const Root_:TMyNode );
//･･････････････････････････････････････････････････････････････････
     procedure AddNode( const Parent_:TFmxObject; const TreeNode_:TMyNode );
     var
        I :Integer;
        P :TTreeViewItem;
        S :String;
     begin
          P := TTreeViewItem.Create( TreeView_ );

          P.Parent := Parent_;

          if Assigned( TreeNode_.Paren ) then S := TreeNode_.Order.ToString
                                         else S := '-';

          P.Text   := S + ' [' + TreeNode_.Name + '] ' + TreeNode_.ChildsN.ToString;

          with TreeNode_ do
          begin
               for I := 0 to ChildsN-1 do AddNode( P, Childs[ I ] );
          end;
     end;
//･･････････････････････････････････････････････････････････････････
begin
     TreeView_.Clear;

     AddNode( TreeView_, Root_ );

     TreeView_.ExpandAll;
end;

//------------------------------------------------------------------------------

function RandNode( const Node_:TMyNode ) :TMyNode;
begin
     Result := Node_.Childs[ Random( Node_.ChildsN ) ];
end;

function RandKnot( const Node_:TMyNode ) :TMyNode;
var
   I, N :Integer;
   P :TMyNode;
   Ps :TArray<TMyNode>;
begin
     with Node_ do
     begin
          SetLength( Ps, ChildsN );

          N := 0;
          for I := 0 to ChildsN-1 do
          begin
               P := Childs[ I ];

               if P.ChildsN > 0 then
               begin
                    Ps[ N ] := P;  Inc( N );
               end;
          end;
     end;

     if N = 0 then Result := nil
              else Result := Ps[ Random( N ) ];
end;

//------------------------------------------------------------------------------

function FindNode( const Node_:TMyNode ) :TMyNode;
begin
     Result := Node_;

     while ( Result.ChildsN > 0 )
       and ( Random( 4 )    > 0 ) do Result := RandNode( Result );
end;

function FindKnot( const Knot_:TMyNode ) :TMyNode;
var
   P :TMyNode;
begin
     Result := Knot_;

     while Random( 4 ) > 0 do
     begin
          P := RandKnot( Result );

          if not Assigned( P ) then Exit;

          Result := P;
     end;
end;

function FindLeaf( const Node_:TMyNode ) :TMyNode;
begin
     Result := Node_;

     while Result.ChildsN > 0 do Result := RandNode( Result );
end;

//------------------------------------------------------------------------------

procedure AddNode( const Root_:TMyNode );
var
   P :TMyNode;
begin
     P := FindNode( Root_ );

     case Random( 2 ) of
       0: TMyNode.Create.Paren := P;
       1: TMyNode.Create( P );
     end;
end;

procedure TransNode( const Root0_,Root1_:TMyNode );
var
   C, P :TMyNode;
begin
     if Root0_.ChildsN > 0 then
     begin
          C := FindLeaf( RandNode( Root0_ ) );
          P := FindNode( Root1_ );

          if P.ChildsN = 0 then
          begin
               case Random( 3 ) of
                 0: C.Paren := P;
                 1: P.InsertHead( C );
                 2: P.InsertTail( C );
               end;
          end
          else
          begin
               case Random( 9 ) of
                 0: C.Paren := P;
                 1: P.InsertHead( C );
                 2: P.InsertTail( C );
                 3: TMyNode( P.Head ).InsertPrev( C );                           {本来キャスト不要}
                 4: TMyNode( P.Head ).InsertNext( C );                           {本来キャスト不要}
                 5: TMyNode( P.Tail ).InsertPrev( C );                           {本来キャスト不要}
                 6: TMyNode( P.Tail ).InsertNext( C );                           {本来キャスト不要}
                 7: TMyNode( P.Childs[ Random( P.ChildsN ) ] ).InsertPrev( C );  {本来キャスト不要}
                 8: TMyNode( P.Childs[ Random( P.ChildsN ) ] ).InsertNext( C );  {本来キャスト不要}
               end;
          end;
     end;
end;

procedure SwapSibliNodes( const Root_:TMyNode );
var
   P, C1, C2 :TMyNode;
   I1, I2 :Integer;
begin
     if Root_.ChildsN > 0 then
     begin
          P := FindKnot( Root_ );

          if Assigned( P ) then
          begin
               C1 := RandNode( P );  I1 := C1.Order;
               C2 := RandNode( P );  I2 := C2.Order;

               case Random( 4 ) of
                 0: C1.Order := I2;
                 1: C2.Order := I1;
                 2: P.Swap( I1, I2 );
                 3: TMyNode.Swap( C1, C2 );
               end;
          end;
     end;
end;

procedure SwapOtherNodes( const Root1_,Root2_:TMyNode );
var
   C1, C2 :TMyNode;
begin
     if ( Root1_.ChildsN > 0 )
     or ( Root2_.ChildsN > 0 ) then
     begin
          C1 := FindLeaf( RandNode( Root1_ ) );
          C2 := FindLeaf( RandNode( Root2_ ) );

          TMyNode.Swap( C1, C2 );
     end;
end;

procedure DelNode( const Root_:TMyNode );
begin
     if Root_.ChildsN > 0 then FindLeaf( RandNode( Root_ ) ).Free;
end;

//############################################################################## □

initialization //######################################################## 初期化

finalization //########################################################## 最終化

end. //######################################################################### ■
