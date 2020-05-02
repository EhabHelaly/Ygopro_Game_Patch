--The Bonded Elegantea Spirits
function c11511039.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,11511039)
	e1:SetTarget(c11511039.target)
	e1:SetOperation(c11511039.operation)
	c:RegisterEffect(e1)
end
function c11511039.filter1(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and lv~=c:GetOriginalLevel() and c:IsFaceup() and c:IsSetCard(0xfff)
	and Duel.IsExistingMatchingCard(c11511039.filter2,tp,LOCATION_DECK,0,1,nil,lv,e,tp)
end
function c11511039.filter2(c,lv,e,tp)
	return c:GetLevel()==lv and c:IsSetCard(0xfff) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11511039.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c11511039.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c11511039.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c11511039.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c11511039.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11511039.filter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetLevel(),e,tp)
	local sc=g:GetFirst()
	if sc then
    Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
