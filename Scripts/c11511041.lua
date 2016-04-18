--Rituals for the Elegantea
function c11511041.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c11511041.con)
	e1:SetOperation(c11511041.operation)
	c:RegisterEffect(e1)

end
function c11511041.filter0(c)
	return c:IsType(TYPE_XYZ) and c:IsFaceup() and c:IsSetCard(0xff)
end
function c11511041.filter1(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsFaceup() and c:IsSetCard(0xff)
	and Duel.IsExistingMatchingCard(c11511041.filter2,tp,LOCATION_MZONE,0,1,c,c:GetRank(),e,tp)
end
function c11511041.filter2(c,rk1,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsFaceup() and c:IsSetCard(0xff)
	and Duel.IsExistingMatchingCard(c11511041.filter3,tp,LOCATION_EXTRA,0,1,nil,rk1,c:GetRank(),e,tp)
end
function c11511041.filter3(c,rk1,rk2,e,tp)
	return c:GetRank() >rk1 and c:GetRank() <rk2  and c:IsSetCard(0xff) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11511041.con(e)
    local tp=e:GetHandler():GetControler()
    local g0=Duel.GetMatchingGroup(c11511041.filter0,tp,LOCATION_MZONE,0,nil)
	if g0:GetCount()>0 then
        local rk1=g0:GetMinGroup(Card.GetRank):GetFirst():GetRank()
        local rk2=g0:GetMaxGroup(Card.GetRank):GetFirst():GetRank()
        return Duel.IsExistingMatchingCard(c11511041.filter3,tp,LOCATION_EXTRA,0,1,nil,rk1,rk2,e,tp)
           and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    else return false end
end
function c11511041.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
 	local c=e:GetHandler()
    local g0=Duel.GetMatchingGroup(c11511041.filter0,tp,LOCATION_MZONE,0,nil)
	if g0:GetCount()>0 then
        local rk1=g0:GetMinGroup(Card.GetRank):GetFirst():GetRank()
        local rk2=g0:GetMaxGroup(Card.GetRank):GetFirst():GetRank()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectTarget(tp,c11511041.filter3,tp,LOCATION_EXTRA,0,1,1,nil,rk1,rk2,e,tp)
        local tc=g:GetFirst()
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
        c:CancelToGrave()
		Duel.Overlay(tc,c)
    end
end
