
(load "lib/marley.l")

(symbols 'entities 'pico)

(local) (+User +Venue +Provider +Service +Itinerary)


(class +Client +Jamaica +Rest)
  (dm home> (User)
    (cond 
      ((not User))
      ((isa '+Winery User))
      ((isa '+Driver User))
      ((isa '+User User))
      ()))
  (dm nav> (User)
    (cond 
      ((not User) ($div '((id . nav)) (list ($a '((href . "/venue/list")) "Browse Venues") ($a '((href . "/provider/list")) "Browse providers") )))
      ((isa '+Winery User) ($div '((id . nav)) (list ($a '((href . "/wines")) "Manage Wines") ($a '((href . "/tastings")) "Manage Tastings") ($a '((href . "/itineraries/")) "Browse Upcoming visitors") )))
      ((isa '+Driver User))
      ((isa '+User User)($div '((id . nav)) (list ($a '((href . "/itins")) "My Itineraries") ($a '((href . "/venue/list")) "Browse Venues") ($a '((href . "/provider/list")) "Browse providers") ($a '((href . "/itinerary/new")) "New Itinerary") )))
      ()))


(class +Nd +Entity)
  (rel lt (+UB +Aux +Ref +Number) (ln) NIL 6 NIL)
  (rel ln (+Number) 6 NIL)                       
  (rel w (+List +Joint +Ref) nd (+Way) NIL)         

(class +Way +Entity)
  (rel nm (+Fold +Ref +String) NIL) 
  (rel nd (+List +Joint +Ref) w (+Nd) NIL)

(class +User +REntity +Rest)
  (var perms (cud r c))
  (rel eml (+Need +Key +Email) (crud r c))
  (rel pw (+Need +Key +Password) (cu NIL c))
  (rel salt (+String) NIL)
  (rel addr (+Idx +String) (crud r c))
  (rel nm (+Need +Sn +Idx +String) (crud r c))
  (rel itins (+List +Joint) cust (+Itinerary) (rud r NIL))

(class +Winery +User)
  (var perms (crud r cr))
  (rel nm (+Need +Sn +Idx +String) (crud r rc))
  (rel desc (+Need +Idx +String) (crud r rc))
  (rel drivers (+List +Joint) wineries (+Driver) (crd crd r))
  (rel tastings (+List +Joint) wineries (+Tasting) (rud r r))
  (rel loc (+Ref +Link) NIL (+Nd) NIL)
  (rel wines (+List +Joint) winery (+Wine) (crud r r r))
  (rel itins (+List +Ref +Joint) NIL wineries (+Itinerary) (r))

(class +Driver +User)
  (var perms (crud r cr))
  (rel nm (+Need +Sn +Idx +String) (crud r rc))
  (rel desc (+Need +Idx +String) (crud r rc))
  (rel wineries (+List +Joint) drivers (+Winery) (rd crd r))
  (rel itins (+List +Joint) driver (+Itinerary) (rd crd NIL))

(class +Tasting +REntity +Rest)
  (var perms (crud rc rm))
  (dm owner> () (get This 'venue))
  (dm group_mem> (User) (isa '+Venue User))
  (dm set_owner>(User) (put> This 'venue User))

  (rel nm (+Need +Sn +Aux +Key +String) (venue) (crud cr rm))
  (rel desc (+Need +Idx +String) (crud rc cm))
  (rel duration (+Need +Number) (crud cr rm))
  (rel price (+Need +Number) (crud cr rm))
  (rel capacity (+Need +Number) (crud cr rm))
  (rel max_grp (+Number) (crud cr rm))
  (rel winery (+Need +Ref +Joint) NIL tastings (+Winery) (rud cr rm))

(class +Wine +REntity)
  (var perms (crud rc r))
  (dm owner> () (get This 'winery))
  (dm set_owner>(User) (put> This 'winery User))
  (dm grp_mem> (User) (= '+Winery (type User)))

  (rel winery (+Ref +Link) wines (+Winery) (cruds r r r))
  (rel nm (+Need +Sn +Idx +String) (crud r rc))
  (rel desc (+Need +Idx +String) (crud r rc))
  (rel price (+Need +Number) (crud r rc))

(class +Itinerary +REntity +Rest)
  (var perms (crud r c NIL))
  (dm owner> () (get This 'cust))
  (dm set_owner>(User) (put> This 'cust User))
  (dm grp_mem> (User) (= User (get This 'provider)))

  (rel start_addr (+Need +String) (crud r cr NIL))
  (rel dt (+Need +Idx +FDate) (crud r cr NIL))
  (rel tm (+Need +FTime) (crud r cr NIL))
  (rel cust (+Joint) itins (+User) (c r NIL))
  (rel ppl (+Need +Number) (crud r rc NIL))
  (rel wineries (+List +Joint) itins (+Winery) (crud r crd NIL))
  (rel driver (+Joint) itins (+Driver) (crud r cr NIL))

(load T)
#(bye)
