--Dragonilian Possedon
function c11511207.initial_effect(c)
	-- sp summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c11511207.sptg)
	e1:SetOperation(c11511207.spop)
	c:RegisterEffect(e1)
end

function c11511207.filterSP(c,e,tp)
	return c:IsSetCard(0xffd) and c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and not Duel.IsExistingMatchingCard(c11511207.filterF,tp,LOCATION_MZONE,0,1,nil,c:GetAttribute())
end
function c11511207.filterF(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function c11511207.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c11511207.filterSP,tp,LOCATION_HAND,0,1,nil,e,tp) end
end
function c11511207.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11511207.filterSP,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
