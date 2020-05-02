--Dragonilian Holomos
function c11511216.initial_effect(c)
	-- sp summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c11511216.sptg)
	e1:SetOperation(c11511216.spop)
	c:RegisterEffect(e1)
end

function c11511216.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c11511216.spfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c11511216.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	e:SetLabelObject(g:GetFirst())
end
function c11511216.spop(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetLabelObject()
	Duel.SendtoGrave(rc,nil,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11511216.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,rc:GetLevel())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c11511216.spfilter1(c,e,tp)
	return c:IsSetCard(0xffd) and c:IsAbleToGraveAsCost() 
	and Duel.IsExistingMatchingCard(c11511216.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,c:GetLevel())
end
function c11511216.spfilter2(c,e,tp,lv)
	return c:IsSetCard(0xffd) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and not Duel.IsExistingMatchingCard(c11511216.spfilter3,tp,LOCATION_MZONE,0,1,nil,c:GetAttribute())
end
function c11511216.spfilter3(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
